// ===================== Faded Mod =====================
//
// lua\FadedTest.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

if (Server) then
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

    local function OnCommandFadedLocation(player)
        local alienTeam = GetGamerules():GetTeam2()
        if (alienTeam:GetNumPlayers() == 0) then return end
        
        local alienPlayerId = alienTeam.playerIds[1];
        local player = Shared.GetEntity(alienPlayerId)
     
        Shared:FadedMessage(player:GetLocationName())
    end

    local function GetDestinationOrigin(origin, direction, player, phaseGate, extents)

        local capusuleOffset = Vector(0, 0.4, 0)
        origin = origin + Vector(0, 0.1, 0)
        if not extents then
            extents = Vector(0.17, 0.2, 0.17)
        end

        // check at first a desired spawn, if that one is free we use that
        if GetHasRoomForCapsule(extents, origin + capusuleOffset, CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, phaseGate) then
            return origin
        end
        
        local numChecks = 6
        
        for i = 0, numChecks do
        
            local offset = direction * (i - numChecks/2) * -0.5
            if GetHasRoomForCapsule(extents, origin + offset + capusuleOffset, CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, phaseGate) then
                origin = origin + offset
                break
            end
            
        end
        
        return origin

    end

    local function OnCommandFadedTeleport(_, player, toPlayer)  
        if (not player or not toPlayer) then
            Shared.Message("fadedteleport <player> <to player>")
            return    
        end    
      
        local teleportToPlayer = Shared:GetPlayerByName(toPlayer)
        local teleportPlayer = Shared:GetPlayerByName(player)
        
        if (teleportToPlayer == nil) then
            Shared.Message(string.format("Couldn't find player '%s'.", toPlayer))
        elseif (teleportPlayer == nil) then
            Shared.Message(string.format("Couldn't find player '%s'.", player))
        else        
            local destOrigin = GetDestinationOrigin(teleportToPlayer:GetOrigin(), teleportToPlayer:GetCoords().zAxis, teleportToPlayer, teleportPlayer:GetExtents())
            teleportPlayer:SetOrigin(destOrigin)
            Shared.Message(string.format("Teleported player '%s' to player '%s'.", teleportPlayer:GetName(), teleportToPlayer:GetName()))
        end    
    end

    local function OnCommandFadedThirdPerson(_, playerName)
        if (not playerName) then
            Shared.Message("fadedthirdperson <playername>")
            return    
        end    

        local player = Shared:GetPlayerByName(playerName)
        
        if (player:GetIsThirdPerson()) then
            player:SetIsThirdPerson(0)
        else
            player:SetIsThirdPerson(4)
        end
    end

    local function OnCommandFadedMe(_, playerName)
        if (not FadedMod.nextFaded) then
            FadedMod.nextFaded = playerName
        else
            FadedMod.nextFaded = nil
        end    
    end
    
    local function OnCommandFadedSpecial(client)
        for _, player in ientitylist(Shared.GetEntitiesWithClassname("Marine")) do
            if (player and player:isa("Marine")) then
                player:SetModel(Marine.kSpecialEditionModelName, Marine.kMarineAnimationGraph)     
            end  
        end
    end
    
    local function OnCommandFadedBlack(client)
        for _, player in ientitylist(Shared.GetEntitiesWithClassname("Marine")) do
            if (player and player:isa("Marine")) then
                player:SetModel(Marine.kBlackArmorModelName, Marine.kMarineAnimationGraph)     
            end  
        end
    end
    
    local function OnCommandFadedGreen(client)
        for _, player in ientitylist(Shared.GetEntitiesWithClassname("Marine")) do
            if (player and player:isa("Marine")) then
                player:SetModel(Marine.kModelName, Marine.kMarineAnimationGraph)   
            end    
        end
    end

    Event.Hook("Console_addbots", OnConsoleAddBots)
    Event.Hook("Console_fadedlocation", OnCommandFadedLocation)
    Event.Hook("Console_fadedteleport", OnCommandFadedTeleport)
    Event.Hook("Console_fadedthirdperson", OnCommandFadedThirdPerson)
    Event.Hook("Console_fadedme", OnCommandFadedMe)
    Event.Hook("Console_fadedspecial", OnCommandFadedSpecial)
    Event.Hook("Console_fadedblack", OnCommandFadedBlack)
    Event.Hook("Console_fadedgreen", OnCommandFadedGreen)
elseif (Client) then    
end    