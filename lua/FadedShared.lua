// ===================== Faded Mod =====================
//
// lua\FadedShared.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

// Load libraries
Script.Load("lua/libs/LibCache/LibCache.lua")
Script.Load("lua/libs/LibLocales-1.0/LibLocales.lua")
Script.Load("lua/libs/LibMessages-1.0/LibMessages.lua")

Script.Load("lua/MarineTeam.lua")
Script.Load("lua/AlienTeam.lua")

Script.Load("lua/FadedGlobals.lua")
Script.Load("lua/FadedCloak.lua")
Script.Load("lua/FadedRoundTimer.lua")
Script.Load("lua/FadedParasite.lua")
Script.Load("lua/FadedFade.lua")
Script.Load("lua/FadedMarine.lua")
Script.Load("lua/FadedMines.lua")
Script.Load("lua/FadedAlien.lua")
Script.Load("lua/FadedVoiceOver.lua")
//Script.Load("lua/FadedRagdoll.lua")

local kSelectEquipmentMessage =
{
    Weapon = "enum kTechId",
    Equipment = "enum kTechId"
}    

Shared.RegisterNetworkMessage("SelectEquipment", kSelectEquipmentMessage)  
Shared.RegisterNetworkMessage("RoundTime", { time = "integer" })

local lastShutdownLights = nil
function ShutdownLights()
    if (lastShutdownLights and (Shared.GetTime() - lastShutdownLights) < 2) then return end
    lastShutdownLights = Shared.GetTime()
    
    local color = Color(kFadedModLightColorScale, kFadedModLightColorScale, kFadedModLightColorScale)
    
    for index, renderLight in ipairs(Client.lightList) do
        renderLight:SetIntensity(kFadedModLightIntensity)    
        renderLight:SetColor(color)
        
        if renderLight:GetType() == RenderLight.Type_AmbientVolume then            
            renderLight:SetDirectionalColor(RenderLight.Direction_Right,    color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Left,     color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Up,       color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Down,     color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Forward,  color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Backward, color)                
        end 
    end    
end

Event.Hook("UpdateClient", ShutdownLights)

// Dont't reset the scoreboard on game reset
function OnCommandOnResetGame()
    //Scoreboard_OnResetGame()
    ResetLights()
end

function Scoreboard_OnResetGame()
end

function Scoreboard_Clear()
end

local libLocale = LibCache:GetLibrary("LibLocales-1.0")
if (Client) then
    function Locale.ResolveString(text)
        return libLocale:ResolveString(text) or ""
    end
end
    
if (Server) then  
    // Returns a random player out of the given player ids.
    function Shared:GetRandomPlayer(playerIds)
        if (playerIds == nil or #playerIds <= 0) then return nil end
        
        local randomPlayerId = playerIds[math.random(#playerIds)]
        local randomPlayer = Shared.GetEntity(randomPlayerId)
        
        return randomPlayer
    end

    function Shared:FadedMessage(chatMessage)
        Server.SendNetworkMessage("Chat", BuildChatMessage(false, "Faded Mod", -1, kTeamReadyRoom, kNeutralTeamType, chatMessage), true)
        Shared.Message("Chat All - Faded Mod: " .. chatMessage)
        Server.AddChatToHistory(chatMessage, "Faded Mod", 0, kTeamReadyRoom, false)
    end

    function Player:FadedMessage(chatMessage)
        self:SendMessage("Faded Mod", chatMessage)
    end

    function MarineTeam:FadedMessage(chatMessage)
        self:SendMessage("Faded Mod", chatMessage)
    end

    function AlienTeam:FadedMessage(chatMessage)
        self:SendMessage("Faded Mod", chatMessage)
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
    Client.HookNetworkMessage("RoundTime", function(data) kFadedModRoundTimerInSecs = data.time end)
end