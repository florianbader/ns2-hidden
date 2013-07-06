// ===================== LibTimer ====================
//
// LibTimer\LibTimer.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local libTimerMajor, libTimerMinor = "LibTimer-1.0", 1
local lib = LibCache:NewLibrary(libTimerMajor, libTimerMinor)
if (not lib) then return end

local tinsert = table.insert
local tremove = table.remove

lib.timedCallbacks = {}

function lib:AddTimedCallback(callback, timeInSeconds)
    tinsert(self.timedCallbacks, { callback = callback, timeInSeconds = timeInSeconds, elapsedTimeInSeconds = 0 })
end

function lib:TimerLoop(elapsedTime)
    for index, timerCallback in pairs(self.timerCallbacks) do
        timerCallback.elapsedTimeInSeconds =  timerCallback.elapsedTimeInSeconds + elapsedTime
        if (timerCallback.elapsedTimeInSeconds >= timeInSeconds) then
            timerCallback.callback()
            tremove(self.timerCallbacks, index)
        end
    end
end

local entityOnUpdate = Entity.OnUpdate
function Entity:OnUpdate(elapsedTime)
    entityOnUpdate(self, elapsedTime)
    lib:TimerLoop(elapsedTime)
end