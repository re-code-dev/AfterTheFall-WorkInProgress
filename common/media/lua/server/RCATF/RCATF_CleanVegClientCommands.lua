--10100101110--10100101111--10100101110--10100101110--
--1010  ____             ____          _        0101--       -- Author : Seppel --
--1111 |  _ \ ___ :  ___/ ___|___   __| | ___   1010--
--1010 | |_) / _ \:  __| |   / _ \ / _` |/ _ \  1111--
--1111 |  _ <  __/: __ \ |__| (_) | (_| |  __/  1010--
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|  1111--
--10100101110--10100101111--10100101110--10100101110--
require("luautils")

local starts = luautils.stringStarts

local REMOVE_PREFIXES = {
    "blends_grassoverlays",
    "d_plants",
    "d_generic",
    "f_wallvines",
    "blends_natural",
    "e_newgrass",
    "vegetation_farm",
}

local function shouldRemoveSpriteName(name)
    if not name then return false end
    for i = 1, #REMOVE_PREFIXES do
        if starts(name, REMOVE_PREFIXES[i]) then
            return true
        end
    end
    return false
end

local function onClientCommand(module, command, player, args)
    if module ~= "CleanVeg" then return end
    if command ~= "CleanVegCommand" then return end
    if not args or args.x == nil or args.y == nil or args.z == nil then return end

    local square = getCell():getGridSquare(args.x, args.y, args.z)
    if not square then return end

    local objects = square:getObjects()
    if not objects then return end

    for i = objects:size() - 1, 0, -1 do
        local obj = objects:get(i)
        if obj and obj.getTextureName and obj:getTextureName() and starts(obj:getTextureName(), "blends_grassoverlays") then
            square:RemoveTileObject(obj)
        else
            local animList = obj and obj.getAttachedAnimSprite and obj:getAttachedAnimSprite() or nil
            if animList then
                for j = animList:size(), 1, -1 do
                    local anim = animList:get(j - 1)
                    local parent = anim and anim:getParentSprite()
                    local name = parent and parent:getName()
                    if shouldRemoveSpriteName(name) then
                        obj:RemoveAttachedAnim(j - 1)
                        obj:transmitUpdatedSpriteToClients()
                    end
                end
            end
        end
    end
end

Events.OnClientCommand.Add(onClientCommand)
