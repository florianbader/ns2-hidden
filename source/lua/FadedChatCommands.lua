// ===================== Faded Mod =====================
//
// lua\FadedChatCommands.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local locale = LibCache:GetLibrary("LibLocales-1.0")

FadedChatCommands = {
    chatCommands = {}
}

local kChatsPerSecondAdded = 1
local kMaxChatsInBucket = 5
local function CheckChatAllowed(client)

    client.chatTokenBucket = client.chatTokenBucket or CreateTokenBucket(kChatsPerSecondAdded, kMaxChatsInBucket)
    // Returns true if there was a token to remove.
    return client.chatTokenBucket:RemoveTokens(1)
    
end

local function GetChatPlayerData(client)

    local playerName = "Admin"
    local playerLocationId = -1
    local playerTeamNumber = kTeamReadyRoom
    local playerTeamType = kNeutralTeamType
    
    if client then
    
        local player = client:GetControllingPlayer()
        if not player then
            return
        end
        playerName = player:GetName()
        playerLocationId = player.locationId
        playerTeamNumber = player:GetTeamNumber()
        playerTeamType = player:GetTeamType()
        
    end
    
    return playerName, playerLocationId, playerTeamNumber, playerTeamType
    
end

local function DetaultOnChatReceived(client, message)

    if not CheckChatAllowed(client) then
        return
    end
    
    chatMessage = string.sub(message.message, 1, kMaxChatLength)
    if chatMessage and string.len(chatMessage) > 0 then
    
        local playerName, playerLocationId, playerTeamNumber, playerTeamType = GetChatPlayerData(client)
        
        if playerName then
        
            if message.teamOnly then
            
                local players = GetEntitiesForTeam("Player", playerTeamNumber)
                for index, player in ipairs(players) do
                    Server.SendNetworkMessage(player, "Chat", BuildChatMessage(true, playerName, playerLocationId, playerTeamNumber, playerTeamType, chatMessage), true)
                end
                
            else
                Server.SendNetworkMessage("Chat", BuildChatMessage(false, playerName, playerLocationId, playerTeamNumber, playerTeamType, chatMessage), true)
            end
            
            Shared.Message("Chat " .. (message.teamOnly and "Team - " or "All - ") .. playerName .. ": " .. chatMessage)
            
            // We save a history of chat messages received on the Server.
            Server.AddChatToHistory(chatMessage, playerName, client:GetUserId(), playerTeamNumber, message.teamOnly)
            
        end
        
    end
    
end

function FadedChatCommands:RegisterChatCommand(command, commandFunction)
    self.chatCommands[command] = commandFunction
end

function FadedChatCommands:TriggerChatCommand(chatMessage, player)
    local processed = false

    for command, commandFunction in pairs(self.chatCommands) do
        if (command:upper() == chatMessage:upper()) then
            commandFunction(player)
            processed = true
        end
    end
    
    return processed
end                

local function OnChatReceived(client, message)
    chatMessage = string.sub(message.message, 1, kMaxChatLength)
    if (chatMessage and string.len(chatMessage) > 0) then    
        local player = client:GetControllingPlayer()    
        if (player) then
            local processed = FadedChatCommands:TriggerChatCommand(chatMessage, player)
            if (not processed) then
                DetaultOnChatReceived(client, message)
            end    
        end
    end    
end

// Friendly fire status command
FadedChatCommands:RegisterChatCommand("ff", function(player)
    if (kFadedModFriendlyFireEnabled) then
        player:FadedMessage(locale:ResolveString("FADED_CHAT_COMMANDS_FF_ENABLED"))
    else
        player:FadedMessage(locale:ResolveString("FADED_CHAT_COMMANDS_FF_DISABLED"))
    end    
end)

// No Faded command
NS2Gamerules.noFaded = {}
local function NoFadedCommand(player)
    local clientIndex = player:GetClientIndex()    
    NS2Gamerules.noFaded[clientIndex] = not NS2Gamerules.noFaded[clientIndex] and true or false
    
    if (not NS2Gamerules.noFaded[clientIndex]) then
        player:FadedMessage(locale:ResolveString("FADED_NO_FADED_FALSE"))
    else
        player:FadedMessage(locale:ResolveString("FADED_NO_FADED_TRUE"))
    end
end

FadedChatCommands:RegisterChatCommand("nofade", NoFadedCommand)
FadedChatCommands:RegisterChatCommand("nofaded", NoFadedCommand)

// Help
FadedChatCommands:RegisterChatCommand("fadedhelp", function(player)
    local teamNumber = player:GetTeamNumber()
    
    if (teamNumber == 1) then
        player:FadedMessage(locale:ResolveString("FADED_HELP_MESSAGE_MARINE_1")) 
        player:FadedMessage(locale:ResolveString("FADED_HELP_MESSAGE_MARINE_2")) 
        player:FadedMessage(locale:ResolveString("FADED_HELP_MESSAGE_MARINE_3")) 
    elseif (teamNumber == 2) then
        player:FadedMessage(locale:ResolveString("FADED_HELP_MESSAGE_FADED_1")) 
        player:FadedMessage(locale:ResolveString("FADED_HELP_MESSAGE_FADED_2"))
        player:FadedMessage(locale:ResolveString("FADED_HELP_MESSAGE_FADED_3"))
    end    
    
    player:FadedMessage(locale:ResolveString("FADED_HELP_MESSAGE_1"))
end)

Server.HookNetworkMessage("ChatClient", OnChatReceived)