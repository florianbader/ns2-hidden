// ===================== Faded Mod =====================
//
// lua\FadedSounds.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

// Supress a few messages like "you need a commander"
local avoidMessageTypes = { kTeamMessageTypes.NoCommander, kTeamMessageTypes.SpawningWait, kTeamMessageTypes.Spawning }

local savedSendTeamMessage = SendTeamMessage
function SendTeamMessage(team, messageType, optionalData)
    if (avoidMessageTypes[messageType]) then
        savedSendTeamMessage(team, messageType, optionalData)
    end    
end

// Remove the "No IPs" sound
function MarineTeam:Update(timePassed)
    PlayingTeam.Update(self, timePassed)
    
    // Update distress beacon mask
    self:UpdateGameMasks(timePassed)
end

// Remove "Soldier is under attack" sound
function Marine:GetDamagedAlertId()
    return nil
end