--10100101110--10100101111--10100101110--10100101110--
--1010  ____            ____          _            0101        Author : Seppel
--1111 |  _ \ ___ : ___/ ___|___   __| | ___       1010   
--1010 | |_) / _ \:/ __| |   / _ \ / _` |/ _ \     1111
--1111 |  _ <  __/:\__ \ |__| (_) | (_| |  __/     1010
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|     1111
--10100101110--10100101111--10100101110--10100101110--

require("luautils")

local RCATF_CleanVegCursor = require("RCATF/RCATF_CleanVegCursor")

local _starts = luautils.stringStarts

local function startCursor(worldObjects, square, playerObj)
    local cursor = RCATF_CleanVegCursor:new(playerObj)
    getCell():setDrag(cursor, playerObj:getPlayerNum())
end

local function hasCleanableVegOnSquare(square)
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
                        if pname and (
                            _starts(pname, "blends_grassoverlays") or
                            _starts(pname, "d_plants") or
                            _starts(pname, "d_generic") or
                            _starts(pname, "f_wallvines") or
                            _starts(pname, "blends_natural") or
                            _starts(pname, "e_newgrass") or
                            _starts(pname, "vegetation_farm")
                        ) then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

local function onFillWorldObjectContextMenu(playerIndex, context, worldObjects)
    local playerObj = getSpecificPlayer(playerIndex)
    if not playerObj or playerObj:getVehicle() then return end

    local square
    for _, obj in ipairs(worldObjects) do
        square = obj:getSquare()
        break
    end
    if not square or not hasCleanableVegOnSquare(square) then
        return
    end

    context:addOption(getText("UI_REMOVE_VEG"), worldObjects, startCursor, square, playerObj)
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
