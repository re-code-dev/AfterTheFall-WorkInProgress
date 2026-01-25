--10100101110--10100101111--10100101110--10100101110--
--1010  ____            ____          _            0101        Author : Seppel
--1111 |  _ \ ___ : ___/ ___|___   __| | ___       1010
--1010 | |_) / _ \:/ __| |   / _ \ / _` |/ _ \     1111
--1111 |  _ <  __/:\__ \ |__| (_) | (_| |  __/     1010
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|     1111
--10100101110--10100101111--10100101110--10100101110--

require("TimedActions/ISBaseTimedAction")

-- Timed action used by the CleanVeg cursor.
RCATF_CleanVegAction = ISBaseTimedAction:derive("RCATF_CleanVegAction")

function RCATF_CleanVegAction:isValid()
    return true
end

function RCATF_CleanVegAction:waitToStart()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    return self.character:shouldBeTurning()
end

function RCATF_CleanVegAction:update()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    self.character:setMetabolicTarget(Metabolics.LightWork)
end

function RCATF_CleanVegAction:start()
    self:setActionAnim("RemoveGrass")
    self:setOverrideHandModels(nil, nil)
    self.square:playSound("RemovePlant")
    self.character:reportEvent("EventCleanVeg")
end

function RCATF_CleanVegAction:stop()
    ISBaseTimedAction.stop(self)
end

function RCATF_CleanVegAction:perform()
    local args = { x = self.square:getX(), y = self.square:getY(), z = self.square:getZ() }
    sendClientCommand(self.character, "CleanVeg", "CleanVegCommand", args)
    ISBaseTimedAction.perform(self)
end

function RCATF_CleanVegAction:new(character, square, maxTime)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.square = square
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = maxTime or 100
    o.caloriesModifier = 10

    if character:isTimedActionInstant() then
        o.maxTime = 1
    end

    return o
end

-- Backwards compatibility (older scripts may still reference CleanVegAction)
CleanVegAction = RCATF_CleanVegAction
