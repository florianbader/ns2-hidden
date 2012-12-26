// ===================== Hidden Mod =====================
//
// lua\hidden_Server.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

// Load the ns2 server script
Script.Load("lua/Server.lua")

// Load hidden mod server scripts
Script.Load("lua/HiddenShared.lua")
Script.Load("lua/HiddenUpgradableMixin.lua")
Script.Load("lua/HiddenTeam.lua")
Script.Load("lua/HiddenAlien.lua")
Script.Load("lua/HiddenCloak.lua")
Script.Load("lua/HiddenGamerules.lua")
Script.Load("lua/HiddenTest.lua")

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