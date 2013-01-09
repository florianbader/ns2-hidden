// ===================== Hidden Mod =====================
//
// lua\HiddenShared.lua
//
//    Created by: rio (rio@myrio.de)
//
// ======================================================

Script.Load("lua/MarineTeam.lua")
Script.Load("lua/AlienTeam.lua")

Script.Load("lua/HiddenGlobals.lua")
Script.Load("lua/HiddenCloak.lua")
Script.Load("lua/HiddenRoundTimer.lua")
Script.Load("lua/HiddenParasite.lua")
Script.Load("lua/HiddenFade.lua")

local kSelectEquipmentMessage =
{
    Weapon = "enum kTechId",
    Equipment = "enum kTechId"
}    

Shared.RegisterNetworkMessage("SelectEquipment", kSelectEquipmentMessage)  
Shared.RegisterNetworkMessage("RoundTime", { time = "integer" })

// Dont't reset the scoreboard on game reset
function OnCommandOnResetGame()
    //Scoreboard_OnResetGame()
    ResetLights()
end

function Scoreboard_OnResetGame()
end
    
if (Server) then  
    // Returns a random player out of the given player ids.
    function Shared:GetRandomPlayer(playerIds)
        if (playerIds == nil or #playerIds <= 0) then return nil end
        
        local randomPlayerId = playerIds[math.random(#playerIds)]
        local randomPlayer = Shared.GetEntity(randomPlayerId)
        
        return randomPlayer
    end

    function Shared:HiddenMessage(chatMessage)
        Server.SendNetworkMessage("Chat", BuildChatMessage(false, "Hidden Mod", -1, kTeamReadyRoom, kNeutralTeamType, chatMessage), true)
        Shared.Message("Chat All - Hidden Mod: " .. chatMessage)
        Server.AddChatToHistory(chatMessage, "Hidden Mod", 0, kTeamReadyRoom, false)
    end

    function Player:HiddenMessage(chatMessage)
        self:SendMessage("Hidden Mod", chatMessage)
    end

    function MarineTeam:HiddenMessage(chatMessage)
        self:SendMessage("Hidden Mod", chatMessage)
    end

    function AlienTeam:HiddenMessage(chatMessage)
        self:SendMessage("Hidden Mod", chatMessage)
    end

    function Shared:GetPlayerByName(playerName)
        for _, team in pairs(GetGamerules():GetTeams()) do
            for _, player in pairs(team:GetPlayers()) do
                if (player:GetName():lower() == playerName:lower()) then
                    return player
                end 
            end
        end   
        
        for _, team in pairs(GetGamerules():GetTeams()) do
            for _, player in pairs(team:GetPlayers()) do
                if (player:GetName():lower():find(playerName:lower())) then
                    return player
                end 
            end
        end   
    end
elseif (Client) then
    Client.HookNetworkMessage("RoundTime", function(data) kHiddenModRoundTimerInSecs = data.time end)
end