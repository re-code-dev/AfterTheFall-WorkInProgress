--10100101110--10100101111--10100101110--10100101110--
--1010  ____            ____          _            0101        Author : Seppel
--1111 |  _ \ ___ : ___/ ___|___   __| | ___       1010   
--1010 | |_) / _ \:/ __| |   / _ \ / _` |/ _ \     1111
--1111 |  _ <  __/:\__ \ |__| (_) | (_| |  __/     1010
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|     1111
--10100101110--10100101111--10100101110--10100101110--

local BaseSquareCursor = require("Starlit/client/BaseSquareCursor")

require("luautils")
require("TimedActions/ISTimedActionQueue")
require("RCATF/TimedActions/RCATF_CleanVegAction")

local RCATF_CleanVegCursor = {}
RCATF_CleanVegCursor.__index = RCATF_CleanVegCursor
setmetatable(RCATF_CleanVegCursor, { __index = BaseSquareCursor })

local _starts = luautils.stringStarts

local VEG_PREFIXES = {
    "blends_grassoverlays",
    "d_plants",
    "d_generic",
    "f_wallvines",
    "blends_natural",
    "e_newgrass",
    "vegetation_farm",
}

local function isVegSpriteName(name)
    if not name then return false end
    for i = 1, #VEG_PREFIXES do
        if _starts(name, VEG_PREFIXES[i]) then
            return true
        end
    end
    return false
end

local function squareHasRemovableVeg(square)
    if not square then return false end
    local objects = square:getObjects()
    if not objects then return false end

    for i = 0, objects:size() - 1 do
        local obj = objects:get(i)
        if obj then
            local tex = obj.getTextureName and obj:getTextureName() or nil
            if tex and _starts(tex, "blends_grassoverlays") then
                return true
            end

            local attached = obj.getAttachedAnimSprite and obj:getAttachedAnimSprite() or nil
            if attached then
                for j = 0, attached:size() - 1 do
                    local anim = attached:get(j)
                    if anim then
                        local parent = anim.getParentSprite and anim:getParentSprite() or nil
                        local pname = parent and parent.getName and parent:getName() or nil
                        if isVegSpriteName(pname) then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

function RCATF_CleanVegCursor:new(player)
    local o = BaseSquareCursor.new(player)
    setmetatable(o, self)
    return o
end

function RCATF_CleanVegCursor:isValidInternal(square)
    return squareHasRemovableVeg(square)
end

function RCATF_CleanVegCursor:select(square, hide)
    if not square then
        return BaseSquareCursor.select(self, square, hide)
    end

    -- Only hide the cursor if we successfully queued the action (walkAdj returns true).
    if luautils.walkAdj(self.player, square, true) then
        ISTimedActionQueue.add(RCATF_CleanVegAction:new(self.player, square, 150))
        return BaseSquareCursor.select(self, square, true)
    end

    return BaseSquareCursor.select(self, square, false)
end

-- Override BaseSquareCursor.render to avoid relying on ISBuildingObject (which may not exist / be require-able in some B42 setups).
function RCATF_CleanVegCursor:render(x, y, z, square)
    if not RCATF_CleanVegCursor.floorSprite then
        RCATF_CleanVegCursor.floorSprite = IsoSprite.new()
        RCATF_CleanVegCursor.floorSprite:LoadFramesNoDirPageSimple("media/ui/FloorTileCursor.png")
    end

    local hc
    if self:isValid(square) then
        hc = getCore():getGoodHighlitedColor()
    else
        hc = getCore():getBadHighlitedColor()
    end

    RCATF_CleanVegCursor.floorSprite:RenderGhostTileColor(
        x, y, z,
        hc:getR(), hc:getG(), hc:getB(),
        0.8
    )
end

return RCATF_CleanVegCursor
