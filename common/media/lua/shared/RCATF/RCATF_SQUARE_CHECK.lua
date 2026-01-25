--10100101110--10100101111--10100101110--10100101110--
--1010  ____             ____          _        0101--       -- Author : Seppel --
--1111 |  _ \ ___ :  ___/ ___|___   __| | ___   1010--
--1010 | |_) / _ \:  __| |   / _ \ / _` |/ _ \  1111--
--1111 |  _ <  __/: __ \ |__| (_) | (_| |  __/  1010--
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|  1111--
--10100101110--10100101111--10100101110--10100101110--

-- Shared square checks used by the RCATF generator.
-- Goal: allow vegetation spawn on valid ground, avoid buildings/water/solids.
-- B42 note: some ground sprites incorrectly report IsoFlagType.water (puddles etc).
-- We therefore whitelist "real" water by sprite-name and ignore those false-positives.

local WATER_NAME_SET = {
    ["blends_natural_02_0"] = true,
    ["blends_natural_02_5"] = true,
    ["blends_natural_02_6"] = true,
    ["blends_natural_02_7"] = true,
}

local function isJavaNull(x)
    if x == nil then return true end
    if _G.null and x == _G.null then return true end
    local s = tostring(x)
    return s == "null" or s:sub(1, 5) == "null:"
end

local function safeCall(obj, methodName, ...)
    local fn = obj and obj[methodName]
    if type(fn) ~= "function" then return nil end
    local ok, res = pcall(fn, obj, ...)
    if ok then return res end
    return nil
end

local function iterSquareObjects(square, cb)
    -- Preferred: returns a Lua/Kahlua table (works across builds and avoids :size() crashes)
    local list = safeCall(square, "getLuaTileObjectList")
    if type(list) == "table" then
        -- ipairs when it works
        for _, obj in ipairs(list) do
            if not isJavaNull(obj) then cb(obj) end
        end
        -- fallback for non-array KahluaTables
        for k, obj in pairs(list) do
            if type(k) == "number" and not isJavaNull(obj) then cb(obj) end
        end
        return
    end

    -- Fallback: Java list
    local objects = safeCall(square, "getObjects")
    if objects and objects.get and objects.size then
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if not isJavaNull(obj) then cb(obj) end
        end
    end
end

local function getSpriteName(obj)
    -- Try sprite name first
    local spr = safeCall(obj, "getSprite")
    if spr and not isJavaNull(spr) then
        local name = safeCall(spr, "getName")
        if type(name) == "string" then return name end
    end
    -- Some objects expose a texture-name (often useful for overlays)
    local tex = safeCall(obj, "getTextureName")
    if type(tex) == "string" then return tex end
    return nil
end

local function isRealWaterName(name)
    if type(name) ~= "string" then return false end
    if WATER_NAME_SET[name] then return true end
    -- Small safety net: most "real" river/lake sprites live in this sheet.
    if name:sub(1, 17) == "blends_natural_02_" then return true end
    return false
end

local function isWaterSquare(square)
    if isJavaNull(square) then return false end
    local found = false
    iterSquareObjects(square, function(obj)
        if found then return end
        local name = getSpriteName(obj)
        if isRealWaterName(name) then
            found = true
        end
    end)
    return found
end

-- Public API used by the generator
function checkSquare(square)
    if isJavaNull(square) then return false end

    -- Water (river/lake) check
    if isWaterSquare(square) then return false end

    -- Indoors / structures
    local room = safeCall(square, "getRoom")
    if room and not isJavaNull(room) then return false end

    local hasStairs = safeCall(square, "HasStairs")
    if hasStairs == nil then hasStairs = safeCall(square, "hasStairs") end
    if hasStairs then return false end

    local hasFloor = safeCall(square, "hasFloor", true)
    if hasFloor == nil then hasFloor = safeCall(square, "hasFloor") end
    if not hasFloor then return false end

    -- Doors
    local door = safeCall(square, "getDoor", true) or safeCall(square, "getDoor", false) or safeCall(square, "haveDoor")
    if door and not isJavaNull(door) then return false end

    -- Avoid tables (if this build exposes square:Is)
    if safeCall(square, "Is", "IsTable") then return false end
    if safeCall(square, "Is", "IsTableTop") then return false end

    -- Solid blockers
    if safeCall(square, "isSolid") then return false end
    if safeCall(square, "isSolidTrans") then return false end

    -- Door frames to adjacent squares
    local cell = safeCall(square, "getCell")
    local x, y, z = safeCall(square, "getX"), safeCall(square, "getY"), safeCall(square, "getZ")
    if cell and x and y and z then
        local function hasDoorFrameTo(nx, ny)
            local sq = safeCall(cell, "getGridSquare", nx, ny, z)
            if sq and not isJavaNull(sq) then
                local df = safeCall(square, "getDoorFrameTo", sq)
                if df and not isJavaNull(df) then return true end
            end
            return false
        end
        if hasDoorFrameTo(x - 1, y) or hasDoorFrameTo(x + 1, y) or hasDoorFrameTo(x, y - 1) or hasDoorFrameTo(x, y + 1) then
            return false
        end
    end

    return true
end

-- Legacy helper (some older generator logic calls this directly)
function checkWater(square)
    if isJavaNull(square) then return false end
    return not isWaterSquare(square)
end

return {
    checkSquare = checkSquare,
    checkWater  = checkWater,
}
