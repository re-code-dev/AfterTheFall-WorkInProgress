--10100101110--10100101111--10100101110--10100101110--
--1010  ____             ____          _        0101--       -- Author : Seppel --
--1111 |  _ \ ___ :  ___/ ___|___   __| | ___   1010--
--1010 | |_) / _ \:  __| |   / _ \ / _` |/ _ \  1111--
--1111 |  _ <  __/: __ \ |__| (_) | (_| |  __/  1010--
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|  1111--
--10100101110--10100101111--10100101110--10100101110--

require("luautils")

local function getSquare(args)
    if not args then return nil end
    return getCell():getGridSquare(args.x, args.y, args.z)
end

local function removeCanBeCut(square)
    if not square then return end
    local objs = square:getObjects()
    if not objs then return end

    for i = objs:size() - 1, 0, -1 do
        local o = objs:get(i)
        if o and o:getSprite() then
            local props = o:getSprite():getProperties()
            if props and props:Is(IsoFlagType.canBeCut) then
                square:RemoveTileObject(o)
            end
        end
    end
end

local function removeCanBeRemoved(square)
    if not square then return end
    local objs = square:getObjects()
    if not objs then return end

    for i = 0, objs:size() - 1 do
        local o = objs:get(i)
        if o then
            local attached = o:getAttachedAnimSprite()
            if attached then
                for j = attached:size(), 1, -1 do
                    local anim = attached:get(j - 1)
                    if anim then
                        local parent = anim:getParentSprite()
                        if parent then
                            local props = parent:getProperties()
                            if props and props:Is(IsoFlagType.canBeRemoved) then
                                o:RemoveAttachedAnim(j - 1)
                                o:transmitUpdatedSpriteToClients()
                            end
                        end
                    end
                end
            end
        end
    end
end

local function onClientCommand(module, command, player, args)
    if module ~= "onRemovePlant" then return end

    local square = getSquare(args)
    if not square then return end

    if command == "canBeCut" then
        removeCanBeCut(square)
    elseif command == "canBeRemoved" then
        removeCanBeRemoved(square)
    end
end

Events.OnClientCommand.Add(onClientCommand)
--10100101110--10100101111--10100101110--10100101110--