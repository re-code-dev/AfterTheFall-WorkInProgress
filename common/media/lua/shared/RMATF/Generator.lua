-- ============================================================
--  Re:Mind — After the Fall (RMATF)
--  Author: Seppel
-- ============================================================

-- Clean-room, TYL-inspired world mutation.
-- Runs per chunk-load (safe + deterministic enough), not per-tick scanning.

RMATF = RMATF or {}
RMATF.Generator = RMATF.Generator or {}
local G = RMATF.Generator

local U = RMATF.Utils
local S = RMATF.Sandbox

require("RMATF/Veg/Data")
require("RMATF/Vines")
local VD = RMATF.Veg and RMATF.Veg.Data

local ModData = ModData
local IsoObject = IsoObject
local IsoTree = IsoTree
local IsoSprite = IsoSprite
local IsoSpriteInstance = IsoSpriteInstance
local ArrayList = ArrayList

local function isWaterSquare(sq)
    if not sq then return true end
    local props = sq:getProperties()
    if props and props:Is(IsoFlagType.water) then return true end
    local o = sq:getObjects()
    if not o then return false end
    for i=0, o:size()-1 do
        local obj = o:get(i)
        if obj and obj:getSprite() then
            local n = obj:getSprite():getName()
            if n and (n:find("water", 1, true) or n:find("river", 1, true)) then
                return true
            end
        end
    end
    return false
end

local function floorName(sq)
    local f = sq and sq:getFloor()
    if not f or not f:getSprite() then return nil end
    return f:getSprite():getName()
end

local function isRoadSquare(sq)
    local n = floorName(sq)
    if not n then return false end
    return (n:find("blends_street_", 1, true) == 1)
        or (n:find("blends_road_", 1, true) == 1)
        or (n:find("street_", 1, true) == 1)
        or (n:find("roads_", 1, true) == 1)
end

local function randPercent(pct)
    if pct <= 0 then return false end
    if pct >= 100 then return true end
    return ZombRand(100) < pct
end

local function addFloorClutter(sq, spriteName)
    if not sq or not spriteName then return false end
    local md = sq:getModData()
    if md and md.RMATF_floor then return false end

    local spr = IsoSprite.getSprite(IsoWorld.instance:getCell():getSpriteManager(), spriteName)
    if not spr then return false end

    local o = IsoObject.new(sq, spr)
    if not o then return false end
    sq:AddSpecialObject(o)
    md.RMATF_floor = true
    return true
end


