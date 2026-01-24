require "RMATF_Core"

-- Stell hier EINEN Vine-Sprite ein, den du sicher hast (später)
-- Für jetzt: lassen wir es leer und testen Walls/Fences erst mal.
local TEST_VINE_SPRITE = nil

local function isExteriorWall(obj)
    if not obj then return false end
    local spr = obj:getSprite()
    if not spr then return false end
    local props = spr:getProperties()
    if not props then return false end
    -- Heuristik: exterior walls haben meistens "WallN"/"WallW" etc. oder Flags.
    -- Wir machen es robust: Name + Properties zusammen.
    local name = spr:getName()
    if name and name:find("walls_exterior") then return true end
    return false
end

local DEBUG_FLOOR_OVERLAY = "blends_natural_01_0"

local function applyOnSquare(sq)
    if not sq then return 0 end
    local applied = 0

    local objs = sq:getObjects()
    for i = 0, objs:size() - 1 do
        local obj = objs:get(i)
        local spr = obj and obj:getSprite()
        local name = spr and spr:getName()

        if name then
            -- Exterior walls
            if RMATF.isWall(name) and name:find("walls_exterior") then
                sq:setOverlaySprite(DEBUG_FLOOR_OVERLAY)
                sq:transmitUpdatedSpriteToClients()
                applied = applied + 1
                break
            end

            -- Fences
            if RMATF.isFence(name) then
                sq:setOverlaySprite(DEBUG_FLOOR_OVERLAY)
                sq:transmitUpdatedSpriteToClients()
                applied = applied + 1
                break
            end
        end
    end

    return applied
end


local function applyAround(radius)
    local player = getPlayer()
    if not player then return end
    local sq = player:getSquare()
    if not sq then return end

    local cx, cy, cz = sq:getX(), sq:getY(), sq:getZ()
    local total = 0

    for x = cx - radius, cx + radius do
        for y = cy - radius, cy + radius do
            local s = getCell():getGridSquare(x, y, cz)
            if s then total = total + applyOnSquare(s) end
        end
    end

    print(string.format("[RMATF] APPLY TEST done. touched=%d (radius=%d)", total, radius))
end

Events.OnKeyPressed.Add(function(key)
    local isCtrl  = isKeyDown(Keyboard.KEY_LCONTROL) or isKeyDown(Keyboard.KEY_RCONTROL)
    local isShift = isKeyDown(Keyboard.KEY_LSHIFT) or isKeyDown(Keyboard.KEY_RSHIFT)

    if not (isCtrl and isShift and key == Keyboard.KEY_V) then return end
    applyAround(15)
end)
