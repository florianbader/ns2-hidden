// ===================== Hidden Mod =====================
//
// lua\HiddenShared.lua
//
//    Created by: rio (rio@myrio.de)
//
// ======================================================

Script.Load("lua/HiddenGlobals.lua")

// Returns a random player out of the given player ids.
function Shared:GetRandomPlayer(playerIds)
    if (playerIds == nil or #playerIds <= 0) then return nil end
    
    local randomPlayerId = playerIds[math.random(#playerIds)]
    local randomPlayer = Shared.GetEntity(randomPlayerId)
    
    return randomPlayer
end

function Shared:HiddenMessage(chatMessage)
    Server.SendNetworkMessage("Chat", BuildChatMessage(false, "Hidden Mod", -1, kTeamReadyRoom, kNeutralTeamType, chatMessage), true)
    self.Message("Chat All - Hidden Mod: " .. chatMessage)
    Server.AddChatToHistory(chatMessage, "Hidden Mod", 0, kTeamReadyRoom, false)
end