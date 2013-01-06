// ===================== LibMessages ====================
//
// LibMessages\LibMessages.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

local libMessagesMajor, libMessagesMinor = "LibMessages-1.0", 1
local lib = LibCache:NewLibrary(libMessagesMajor, libMessagesMinor)
if (not lib) then return end

Script.Load("lua/Player.lua")

if (Server) then
    function Player:SendMessage(chatName, chatMessage, teamMessage, locationId)
        assert(type(chatMessage) == "string", "chatMessage needs to be a string")
        assert(type(chatName) == "string", "chatName needs to be a string")
        
        teamMessage = teamMessage or true
        assert(type(teamMessage) == "boolean", "teamMessage needs to be a boolean")
        local teamNumber = teamMessage and self:GetTeamNumber() or kTeamReadyRoom   
        
        locationId = locationId or -1
        assert(type(locationId) == "number", "locationId needs to be a number")
                     
        Server.SendNetworkMessage(self, "Chat", BuildChatMessage(true, chatName, locationId, teamNumber, kNeutralTeamType, chatMessage), true)
    end
    
    function Team:SendMessage(chatName, chatMessage, teamMessage, locationId)
        local players = GetEntitiesForTeam("Player", self.teamNumber)
        for index, player in ipairs(players) do
            player:SendMessage(chatName, chatMessage, teamMessage, locationId)
        end    
    end
    
    function lib:SendPlayerMessage(player, chatName, chatMessage, teamMessage, locationId)
        assert(type(player) == "string" or player:isa("Player"), "player needs to be a string or a Player object")
        
        if (not player:isa("Player")) then
            player = Shared:GetPlayerByName(player)
            assert(player, "player not found")
        end
        
        player:SendMessage(chatMessage, teamMessage, locationId)
    end
    
    if (not Shared.GetPlayerByName) then
        function Shared:GetPlayerByName(playerName)
            for _, team in pairs(GetGamerules():GetTeams()) do
                for _, player in pairs(team:GetPlayers()) do
                    if (player:GetName():lower():find(playerName)) then
                        return player
                    end 
                end
            end   
        end
    end
end    