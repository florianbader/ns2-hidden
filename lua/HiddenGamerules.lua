// ===================== Hidden Mod =====================
//
// lua\HiddenGamerules.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

local locale = LibCache:GetLibrary("LibLocales-1.0")
local strformat = string.format
local floor = math.floor

local hiddenPlayer = nil
local hiddenPregameTenSecMessage = false
local hiddenPregameFiveSecMessage = false
local hiddenModLastTimeTwoPlayersToStartMessage = nil

if (Server) then  
    // Checks if the hidden is dead
    function NS2Gamerules:CheckIfHiddenIsDead()
        return self:CheckIfAllDead(self.team2)
    end
    
    // Checks if the marines are dead
    function NS2Gamerules:CheckIfMarinesAreDead()
        return self:CheckIfAllDead(self.team1)
    end
    
    function NS2Gamerules:CheckIfAllDead(team)
        local playerIds = team.playerIds
            
        for _, playerId in ipairs(playerIds) do
            local player = Shared.GetEntity(playerId)
            
            if player ~= nil and player:GetId() ~= Entity.invalidId and player:GetIsAlive() then            
                return false             
            end        
        end
        
        return true    
    end

    // Only allow players to join the marine team
    function NS2Gamerules:GetCanJoinTeamNumber(teamNumber)
        return (teamNumber ~= 2)
    end
    
    // Only allow players to join the marine team
    local joinTeam = NS2Gamerules.JoinTeam    
    function NS2Gamerules:JoinTeam(player, newTeamNumber, force)
        if (newTeamNumber == 2 and not force) then
            player:HiddenMessage(locale:ResolveString("JOIN_ERROR_TOO_MANY"))
            return false, player
        end

        return joinTeam(self, player, newTeamNumber, force) 
    end
        
    // Allow friendly fire to help the Hidden a bit
    function NS2Gamerules:GetFriendlyFire() return true end
    function GetFriendlyFire() return true end
    
    // Define the game ending rules
    function NS2Gamerules:CheckGameEnd()    
        if (self:GetGameStarted() and self.timeGameEnded == nil and not self.preventGameEnd) then        
            if (self.timeLastGameEndCheck == nil or (Shared.GetTime() > self.timeLastGameEndCheck + 1)) then
                local team1Players = self.team1:GetNumPlayers()
                local team2Players = self.team2:GetNumPlayers()
                
                if (team1Players == 0) then
                    Shared:HiddenMessage(locale:ResolveString("HIDDEN_NO_MARINES_LEFT"))
                    self:EndGame(self.team2)
                elseif (team2Players == 0) then
                    Shared:HiddenMessage(locale:ResolveString("HIDDEN_NO_HIDDEN_LEFT"))
                    self:EndGame(self.team1)    
                elseif (self:CheckIfHiddenIsDead() == true) then
                    Shared:HiddenMessage(locale:ResolveString("HIDDEN_MARINES_VICTORY"))
                    self:EndGame(self.team1)
                elseif (self:CheckIfMarinesAreDead() == true) then                
                    Shared:HiddenMessage(locale:ResolveString("HIDDEN_VICTORY"))
                    self:EndGame(self.team2)
                elseif (HiddenRoundTimer:GetIsRoundTimeOver()) then       
                    Shared:HiddenMessage(locale:ResolveString("HIDDEN_ROUND_TIME_OVER"))
                    self:EndGame(self.team1)
                end    
                
                self.timeLastGameEndCheck = Shared.GetTime()
            end
        end
    end
                   
    // Define the rules for the game start
    function NS2Gamerules:CheckGameStart()
        if self:GetGameState() == kGameState.NotStarted or self:GetGameState() == kGameState.PreGame then
            local team1Players = self.team1:GetNumPlayers()
            local team2Players = self.team2:GetNumPlayers()
            
            if (team1Players == 1 and Shared.GetTime() - (hiddenModLastTimeTwoPlayersToStartMessage or 0) > kHiddenModTwoPlayerToStartMessage) then
                Shared:HiddenMessage(locale:ResolveString("HIDDEN_GAME_NEEDS_TWO_PLAYERS"))
                hiddenModLastTimeTwoPlayersToStartMessage = Shared.GetTime()
            elseif (team1Players > 1 or (team1Players > 0 and team2Players > 0)) then
                self:SetGameState(kGameState.PreGame)
            elseif self:GetGameState() == kGameState.PreGame then
                self:SetGameState(kGameState.NotStarted)
            end 
        end    
    end
    
    local resetGame = NS2Gamerules.ResetGame
    function NS2Gamerules:ResetGame()
        // Disable auto team balance
        Server.SetConfigSetting("auto_team_balance", nil)
    
        // Switch the hidden to the marine team   
        if (self.team2:GetNumPlayers() > 0) then        
            for i, playerId in ipairs(self.team2.playerIds) do
                local alienPlayer = Shared.GetEntity(playerId)                    
                self:JoinTeam(alienPlayer, 1, true)
            end    
        end  
         
        hiddenPlayer = nil 
        
        // Reset the mod
        HiddenRoundTimer:Reset()
        
        // Reset the game
        resetGame(self)
        
        // Choose a random player as Hidden
        if (hiddenPlayer == nil) then
            local player
            if (not HiddenMod.nextHidden) then
                player = Shared:GetRandomPlayer(self.team1.playerIds)
            else
                // Some cheating for the dev mode
                player = Shared:GetPlayerByName(HiddenMod.nextHidden)
                if (not player) then 
                    player = Shared:GetRandomPlayer(self.team1.playerIds)
                end    
            end    
            
            if (player) then                
                // Switch the Hidden to the alien team and give him some upgrades!
                self:JoinTeam(player, 2, true)
                HiddenMod:SpawnAsFade()
                
                // Some info messages
                self:GetTeam1():HiddenMessage(strformat(locale:ResolveString("HIDDEN_PLAYER_IS_NOW_THE_HIDDEN"), player:GetName()))
                self:GetTeam1():HiddenMessage(locale:ResolveString("HIDDEN_MARINE_GAME_STARTED_1"))
                self:GetTeam1():HiddenMessage(locale:ResolveString("HIDDEN_MARINE_GAME_STARTED_2"))
                
                self:GetTeam2():HiddenMessage(strformat(locale:ResolveString("HIDDEN_YOU_ARE_NOW_THE_HIDDEN"), player:GetName()))
                self:GetTeam2():HiddenMessage(locale:ResolveString("HIDDEN_GAME_STARTED"))     
           
                if (kHiddenModVersion:lower():find("development")) then
                    Shared:HiddenMessage("Warning! This is a development version! It's for testing purpose only!")
                elseif (kHiddenModVersion:lower():find("alpha")) then
                    Shared:HiddenMessage("Warning! This is an alpha version, which means it's not finished yet!")
                end    
            end
        end  
        
        // Remove all power nodes, resource points
        local removeEntities = { "ResourcePoint", "PowerPoint" }
        for i, entityType in ipairs(removeEntities) do
            for index, entity in ientitylist(Shared.GetEntitiesWithClassname(entityType)) do
                DestroyEntity(entity)
            end    
        end
    end
        
    // Reset the game on round end
    function NS2Gamerules:UpdateToReadyRoom()
        local state = self:GetGameState()
        if (state == kGameState.Team1Won or state == kGameState.Team2Won or state == kGameState.Draw) then        
            if (self.timeSinceGameStateChanged >= kHiddenModTimeTillNewRound) then                                
                // Reset the game
                self:ResetGame()            
    
                // Set game state to countdown
                self:SetGameState(kGameState.Countdown)                
                self.countdownTime = 6        
                self.lastCountdownPlayed = nil
            end
        end    
    end
        
    // Display a timer on pre game
    local updatePregame = NS2Gamerules.UpdatePregame
    function NS2Gamerules:UpdatePregame(timePassed)
        if (self:GetGameState() == kGameState.PreGame) then        
            local preGameTime = kHiddenModPregameLength  
                        
            if (self.timeSinceGameStateChanged > preGameTime) then
                hiddenPregameTenSecMessage = false
                hiddenPregameFiveSecMessage = false
            else
                if (hiddenPregameFiveSecMessage == false and floor(preGameTime - self.timeSinceGameStateChanged) == 5) then
                    Shared:HiddenMessage(strformat(locale:ResolveString("HIDDEN_GAME_STARTS_IN"), 5)) 
                    hiddenPregameFiveSecMessage = true
                    hiddenPregameTenSecMessage = true
                elseif (hiddenPregameTenSecMessage == false and floor(preGameTime - self.timeSinceGameStateChanged) == 10) then
                    Shared:HiddenMessage(strformat(locale:ResolveString("HIDDEN_GAME_STARTS_IN"), 10))
                    hiddenPregameTenSecMessage = true
                end        
            end
        end    
    
        updatePregame(self, timePassed)
    end
    
    local updateMapCycle = NS2Gamerules.UpdateMapCycle
    function NS2Gamerules:UpdateMapCycle()
        if (state == kGameState.Team1Won or state == kGameState.Team2Won or state == kGameState.Draw) then 
            updateMapCycle(self)
        end
    end
    
    // Hook into the update function, so we can update our mod    
    local onUpdate = NS2Gamerules.OnUpdate
    function NS2Gamerules:OnUpdate(timePassed)
        if (Server) then
            if (self:GetMapLoaded()) then
                // Update the mod
                if (self:GetGameState() == kGameState.Started) then
                    // no longer needed, as we have the GUI timer now
                    //HiddenRoundTimer:UpdateRoundTimer()
                end    
            end    
        end
        
        // Call the NS2Gamerules update function
        onUpdate(self, timePassed)
    end
    
    // get ALL the tech!
    function NS2Gamerules:GetAllTech()
        return true
    end
    
    // Welcome message!    
    function NS2Gamerules:OnClientConnect(client)        
        Gamerules.OnClientConnect(self, client)
        
        local player = client:GetControllingPlayer()
        
        player:HiddenMessage(locale:ResolveString("HIDDEN_WELCOME_MESSAGE_1"))
        player:HiddenMessage(locale:ResolveString("HIDDEN_WELCOME_MESSAGE_2"))
        player:HiddenMessage(locale:ResolveString("HIDDEN_WELCOME_MESSAGE_3"))
        player:HiddenMessage(locale:ResolveString("HIDDEN_WELCOME_MESSAGE_4"))
    end
end