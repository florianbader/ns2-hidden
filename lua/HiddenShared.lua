// ===================== Hidden Mod =====================
//
// lua\HiddenShared.lua
//
//    Created by: rio (rio@myrio.de)
//
// ======================================================

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

function Shared:HiddenMessagePrivate(chatMessage, recv)    
    local player = recv
    if (not recv:isa("Player")) then
        player = GetPlayerByName(recv)
    end
    
    Server.SendNetworkMessage(player, "Chat", BuildChatMessage(true, "Hidden Mod", -1, player:GetTeamNumber(), kNeutralTeamType, chatMessage), true)
end

function Shared:HiddenMessageMarines(chatMessage)
    local players = GetEntitiesForTeam("Player", 1)
    for index, player in ipairs(players) do
        Shared:HiddenMessagePrivate(chatMessage, player)
    end
end

function Shared:HiddenMessageHidden(chatMessage)
    local players = GetEntitiesForTeam("Player", 2)
    for index, player in ipairs(players) do
        Shared:HiddenMessagePrivate(chatMessage, player)
    end
end

function Shared:GetPlayerByName(playerName)
    for _, team in pairs(GetGamerules():GetTeams()) do
        for _, player in pairs(team:GetPlayers()) do
            if (player:GetName():lower():find(playerName)) then
                return player
            end 
        end
    end   
end