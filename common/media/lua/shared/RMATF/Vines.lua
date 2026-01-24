-- ============================================================
--  Re:Mind — After the Fall (RMATF)
--  Vines.lua (B42.13.x) — wall/fence vines, robust + visible
-- ============================================================
--
-- Key changes vs v1:
--   * Validate sprite exists before setting overlay (prevents "applied but invisible")
--   * Roll per object (not just once per square)
--   * Allow up to 2 vines per square (north+west walls)
--   * Debug counters (only if SandboxVars.RMATF.Debug == true)
--
RMATF = RMATF or {}
RMATF.Vines = RMATF.Vines or {}
local V = RMATF.Vines

local Data = require("RMATF/Veg/Data")

local function dbg(fmt, ...)
    if SandboxVars and SandboxVars.RMATF and SandboxVars.RMATF.Debug then
        print("[RMATF] Vines: " .. string.format(fmt, ...))
    end
end

local function safe(fn, ...)
    local ok, res = pcall(fn, ...)
    if ok then return res end
    return nil
end

local function randPercent(pct)
    if pct <= 0 then return false end
    if pct >= 100 then return true end
    return ZombRand(100) < pct
end

-- -------------------------------
-- Sprite existence cache
-- -------------------------------
local SPR_OK = {}
local function spriteExists(spriteName)
    if not spriteName then return false end
    local cached = SPR_OK[spriteName]
    if cached ~= nil then return cached end

    local ok = safe(function()
        local sm = IsoWorld.instance:getCell():getSpriteManager()
        local spr = IsoSprite.getSprite(sm, spriteName)
        return spr ~= nil
    end)

    SPR_OK[spriteName] = ok == true
    return SPR_OK[spriteName]
end

local function pickFrom(list)
    if not list or #list == 0 then return nil end
    return list[ZombRand(#list) + 1]
end

local function pickVineFor(obj)
    local props = safe(obj.getSprite, obj)
    props = props and safe(props.getProperties, props) or nil

    local function has(k)
        return props and safe(props.Is, props, k) == true
    end

    -- Prefer rails for fences/railings
    local candidates = nil
    if has("Fence") or has("Railing") then
        local r = ZombRand(3)
        if r == 0 then candidates = Data.OVERLAY_VINES_RAIL_A end
        if r == 1 then candidates = Data.OVERLAY_VINES_RAIL_B end
        if r == 2 then candidates = Data.OVERLAY_VINES_RAIL_C end
    else
        local r = ZombRand(3)
        if r == 0 then candidates = Data.OVERLAY_VINES_WALLSET_A end
        if r == 1 then candidates = Data.OVERLAY_VINES_WALLSET_B end
        if r == 2 then candidates = Data.OVERLAY_VINES_WALLSET_C end
    end

    -- Try several times to find a sprite that actually exists in this build
    for _ = 1, 10 do
        local vine = pickFrom(candidates)
        if vine and spriteExists(vine) then return vine end
    end

    -- Fallback to known-safe vanilla vine sprite
    local fallback = "f_wallvines_1_36"
    if spriteExists(fallback) then return fallback end

    -- Last resort: any vine from Data.getRandomVine (if present)
    if Data.getRandomVine then
        for _ = 1, 10 do
            local v = Data.getRandomVine()
            if v and spriteExists(v) then return v end
        end
    end
    return nil
end

local function getSpriteName(obj)
    local spr = safe(obj.getSprite, obj)
    if not spr then return nil end
    return safe(spr.getName, spr)
end

local function isWallOrFence(obj)
    -- Prefer properties if available
    local spr = safe(obj.getSprite, obj)
    local props = spr and safe(spr.getProperties, spr) or nil
    local function has(k)
        return props and safe(props.Is, props, k) == true
    end
    if has("WallN") or has("WallW") or has("WallNW") then return true end
    if has("Fence") or has("Railing") then return true end

    -- Name fallback
    local n = getSpriteName(obj)
    if not n then return false end
    return (n:find("walls_", 1, true) == 1)
        or (n:find("fencing_", 1, true) == 1)
        or (n:find("fencing_damaged_", 1, true) == 1)
        or (n:find("location_", 1, true) == 1)
end

local function markOnce(obj)
    local md = safe(obj.getModData, obj)
    if not md then return false end
    if md.RMATF_vine then return false end
    md.RMATF_vine = true
    return true
end

local function trySetOverlay(obj, vineName)
    if not obj or not vineName then return false end
    if not spriteExists(vineName) then return false end

    if obj.setOverlaySprite then
        -- Try 2-arg, then 1-arg
        local ok2 = safe(function() obj:setOverlaySprite(vineName, false) end)
        if ok2 ~= nil then return true end
        local ok1 = safe(function() obj:setOverlaySprite(vineName) end)
        if ok1 ~= nil then return true end
    end
    return false
end

local function tryAttachedFallback(obj, vineName)
    if not obj or not vineName then return false end
    if not spriteExists(vineName) then return false end
    if not obj.getAttachedAnimSprite or not obj.setAttachedAnimSprite then return false end

    local sm = IsoWorld.instance:getCell():getSpriteManager()
    local spr = IsoSprite.getSprite(sm, vineName)
    if not spr then return false end

    local list = obj:getAttachedAnimSprite()
    if not list then
        list = ArrayList.new()
        obj:setAttachedAnimSprite(list)
    end

    local inst = spr:newInstance()
    if not inst then return false end
    list:add(inst)
    return true
end

-- Apply vines on one square. pct is 0..100.
function V.applyOnSquare(sq, pct)
    if not sq or pct <= 0 then return 0 end

    local objs = sq:getObjects()
    if not objs then return 0 end

    local applied = 0
    local maxPerSquare = 2

    for i = 0, objs:size()-1 do
        if applied >= maxPerSquare then break end
        local obj = objs:get(i)

        if obj and isWallOrFence(obj) then
            local md = safe(obj.getModData, obj)
            if not (md and md.RMATF_vine) then
                if randPercent(pct) then
                    local vine = pickVineFor(obj)
                    if vine then
                        local did = trySetOverlay(obj, vine) or tryAttachedFallback(obj, vine)
                        if did and markOnce(obj) then
                            applied = applied + 1
                            if obj.transmitUpdatedSpriteToServer then
                                safe(obj.transmitUpdatedSpriteToServer, obj)
                            end
                        end
                    end
                end
            end
        end
    end

    return applied
end

return V
