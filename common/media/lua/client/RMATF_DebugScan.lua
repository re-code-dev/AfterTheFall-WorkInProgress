require "RMATF_Core"

local function scanAround(radius)
    local player = getPlayer()
    if not player then return end

    local sq = player:getSquare()
    if not sq then return end

    local cx, cy, cz = sq:getX(), sq:getY(), sq:getZ()

    local counts = {wall=0, fence=0, vine=0, other=0}
    local unique = {}

    for x = cx - radius, cx + radius do
        for y = cy - radius, cy + radius do
            local s = getCell():getGridSquare(x, y, cz)
            if s then
                for i = 0, s:getObjects():size()-1 do
                    local obj = s:getObjects():get(i)
                    local spr = obj and obj:getSprite()
                    local name = spr and spr:getName()

                    if name and not unique[name] then
                        unique[name] = true
                        if RMATF.isWall(name) then counts.wall = counts.wall + 1
                        elseif RMATF.isFence(name) then counts.fence = counts.fence + 1
                        elseif RMATF.isVine(name) then counts.vine = counts.vine + 1
                        else counts.other = counts.other + 1 end
                    end
                end
            end
        end
    end

    print(string.format("[RMATF] Unique sprites in radius %d -> wall=%d fence=%d vine=%d other=%d",
        radius, counts.wall, counts.fence, counts.vine, counts.other))
end

Events.OnKeyPressed.Add(function(key)
    local isCtrl  = isKeyDown(Keyboard.KEY_LCONTROL) or isKeyDown(Keyboard.KEY_RCONTROL)
    local isShift = isKeyDown(Keyboard.KEY_LSHIFT) or isKeyDown(Keyboard.KEY_RSHIFT)

    if not (isCtrl and isShift and key == Keyboard.KEY_B) then return end
    scanAround(20)
end)
