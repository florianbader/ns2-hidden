// ===================== Hidden Mod =====================
//
// lua\HiddenTest.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

function OnConsoleAddBots(client, numBotsParam, forceTeam, className, passive)
    local class = BotPlayer

    if className == "test" then
        class = BotTest
    end

    local numBots = 1
    if numBotsParam then
        numBots = math.max(tonumber(numBotsParam), 1)
    end
    
    for index = 1, numBots do    
        local bot = class()
        bot:Initialize(tonumber(forceTeam), not passive)
        table.insert( server_bots, bot )   
    end
end

local function OnCommandHidden(player)
    Shared.Message(string.format("Hidden mod: version %s", kHiddenModVersion or "error"))
end

local function OnCommandHiddenLocation(player)
    local alienTeam = GetGamerules():GetTeam2()
    if (alienTeam:GetNumPlayers() == 0) then return end
    
    local alienPlayerId = alienTeam.playerIds[1];
    local player = Shared.GetEntity(alienPlayerId)
 
    Shared:HiddenMessage(player:GetLocationName())
end

Event.Hook("Console_hidden", OnCommandHidden)
Event.Hook("Console_addbots", OnConsoleAddBots)
Event.Hook("Console_hiddenlocation", OnCommandHiddenLocation)