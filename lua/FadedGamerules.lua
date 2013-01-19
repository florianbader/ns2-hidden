// ===================== Faded Mod =====================
//
// lua\FadedGamerules.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local locale = LibCache:GetLibrary("LibLocales-1.0")
local strformat = string.format
local floor = math.floor
local random = math.random
local tinsert = table.insert

fadedNextPlayer = nil
fadedPlayer = nil

local fadedPregameTenSecMessage = false
local fadedPregameFiveSecMessage = false
local fadedModLastTimeTwoPlayersToStartMessage = nil

local fadedMapTime = 0

local cycle = MapCycle_GetMapCycle()

if (Server) then  
    // Checks if the faded is dead
    function NS2Gamerules:CheckIfFadedIsDead()
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

    // Only allow players to join the marine and random team
    function NS2Gamerules:GetCanJoinTeamNumber(teamNumber)
        return (teamNumber ~= 2)
    end
    
    // Only allow players to join the marine team
    local joinTeam = NS2Gamerules.JoinTeam    
    function NS2Gamerules:JoinTeam(player, newTeamNumber, force)
        if (newTeamNumber == 2 and not force) then
            player:FadedMessage(locale:ResolveString("JOIN_ERROR_TOO_MANY"))
            return false, player
        end

        return joinTeam(self, player, newTeamNumber, force) 
    end
        
    // Allow friendly fire to help the Faded a bit
    function NS2Gamerules:GetFriendlyFire() return kFadedModFriendlyFireEnabled end
    function GetFriendlyFire() return kFadedModFriendlyFireEnabled end
    
    // Define the game ending rules
    function NS2Gamerules:CheckGameEnd()    
        if (self:GetGameStarted() and self.timeGameEnded == nil and not self.preventGameEnd) then        
            if (self.timeLastGameEndCheck == nil or (Shared.GetTime() > self.timeLastGameEndCheck + 1)) then
                local team1Players = self.team1:GetNumPlayers()
                local team2Players = self.team2:GetNumPlayers()
                
                if (team1Players == 0) then
                    Shared:FadedMessage(locale:ResolveString("FADED_NO_MARINES_LEFT"))
                    self:EndGame(self.team2)
                elseif (team2Players == 0) then
                    Shared:FadedMessage(locale:ResolveString("FADED_NO_FADED_LEFT"))
                    self:EndGame(self.team1)    
                elseif (self:CheckIfFadedIsDead() == true) then
                    Shared:FadedMessage(locale:ResolveString("FADED_MARINES_VICTORY"))
                    self:EndGame(self.team1)
                elseif (self:CheckIfMarinesAreDead() == true) then                
                    Shared:FadedMessage(locale:ResolveString("FADED_VICTORY"))
                    self:EndGame(self.team2)
                    
                    // If the Faded wins, the player has a higher chance to be the Faded next round
                    if (fadedPlayer) then
                        local player = Shared:GetPlayerByName(fadedPlayer)
                        if (player) then
                            fadedNextPlayer = player:GetName()
                            player:FadedMessage(locale:ResolveString("FADED_SELECTION_ALIEN"))
                        end
                    end    
                elseif (FadedRoundTimer:GetIsRoundTimeOver()) then       
                    Shared:FadedMessage(locale:ResolveString("FADED_ROUND_TIME_OVER"))
                    self:DrawGame()
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
            
            if (team1Players == 1 and Shared.GetTime() - (fadedModLastTimeTwoPlayersToStartMessage or 0) > kFadedModTwoPlayerToStartMessage) then
                Shared:FadedMessage(locale:ResolveString("FADED_GAME_NEEDS_TWO_PLAYERS"))
                fadedModLastTimeTwoPlayersToStartMessage = Shared.GetTime()
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
    
        // Switch the faded to the marine team   
        if (self.team2:GetNumPlayers() > 0) then        
            for i, playerId in ipairs(self.team2.playerIds) do
                local alienPlayer = Shared.GetEntity(playerId)                    
                self:JoinTeam(alienPlayer, 1, true)
            end    
        end  
                 
        // Reset the mod
        FadedRoundTimer:Reset()
        
        // Save player scores
        local playerScores = {}
        
        local allPlayers = Shared.GetEntitiesWithClassname("Player")
        for _, fromPlayer in ientitylist(allPlayers) do
            local score = 0
            if HasMixin(fromPlayer, "Scoring") then
                score = fromPlayer:GetScore()
            end    
        
            local playerScore = {
                Score = score,
                Kills = fromPlayer:GetKills(),
                Deaths = fromPlayer:GetDeaths()
            }      

            local clientIndex = fromPlayer:GetClientIndex()
            playerScores[clientIndex] = playerScore
        end
        
        // Reset the game
        resetGame(self)
        
        // Restore player scores
        local allPlayers = Shared.GetEntitiesWithClassname("Player")
        for _, fromPlayer in ientitylist(allPlayers) do
            local clientIndex = fromPlayer:GetClientIndex()
            
            if HasMixin(fromPlayer, "Scoring") then
                fromPlayer:AddScore(playerScores[clientIndex].Score, 0)
            end    
            
            fromPlayer.kills = playerScores[clientIndex].Kills
            fromPlayer.deaths = playerScores[clientIndex].Deaths
        end
        
        // Choose a random player as Faded
        local player
        if (not FadedMod.nextFaded) then
            if (fadedNextPlayer) then
                local randomNumber = random()
                if (randomNumber < kFadedModFadedSelectionChance) then
                    player = Shared:GetPlayerByName(fadedNextPlayer)
                end    
            end
            
            if (not player) then            
                player = Shared:GetRandomPlayer(self.team1.playerIds)
            end    
        else
            // Some cheating for the dev mode
            player = Shared:GetPlayerByName(FadedMod.nextFaded)
            if (not player) then 
                player = Shared:GetRandomPlayer(self.team1.playerIds)
            end    
        end    
        
        if (player) then    
            fadedPlayer = player:GetName()
         
            // Switch the Faded to the alien team and give him some upgrades!
            self:JoinTeam(player, 2, true)
            FadedMod:SpawnAsFade()
            
            // Some info messages
            self:GetTeam1():FadedMessage(strformat(locale:ResolveString("FADED_PLAYER_IS_NOW_THE_FADED"), player:GetName()))
            self:GetTeam1():FadedMessage(locale:ResolveString("FADED_MARINE_GAME_STARTED_1"))
            if (kFadedModFriendlyFireEnabled) then
                self:GetTeam1():FadedMessage(locale:ResolveString("FADED_MARINE_GAME_STARTED_2"))
            end    
            
            self:GetTeam2():FadedMessage(strformat(locale:ResolveString("FADED_YOU_ARE_NOW_THE_FADED"), player:GetName()))
            self:GetTeam2():FadedMessage(locale:ResolveString("FADED_GAME_STARTED"))     
       
            if (kFadedModVersion:lower():find("development")) then
                Shared:FadedMessage("Warning! This is a development version! It's for testing purpose only!")
            elseif (kFadedModVersion:lower():find("alpha")) then
                Shared:FadedMessage("Warning! This is an alpha version, which means it's not finished yet!")
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
            // Check if we need to change the map            
            if (fadedMapTime >= (cycle.time * 60)) then
                self.timeToCycleMap = Shared.GetTime() + kFadedModTimeTillMapChange
                fadedMapTime = 0
            else         
                if (self.timeSinceGameStateChanged >= kFadedModTimeTillNewRound) then                                
                    // Reset the game
                    self:ResetGame()            
                    
                    // See if there are enough players, otherwise stop the game
                    local team1Players = self.team1:GetNumPlayers()
                    local team2Players = self.team2:GetNumPlayers()
                    
                    if (team1Players <= 1) then
                        // Set game state to not started
                        self:SetGameState(kGameState.NotStarted)                
                        self.countdownTime = 6        
                        self.lastCountdownPlayed = nil
                    else    
                        // Set game state to countdown
                        self:SetGameState(kGameState.Countdown)                
                        self.countdownTime = 6        
                        self.lastCountdownPlayed = nil
                    end    
                end
            end    
        end    
    end
        
    // Display a timer on pre game
    local updatePregame = NS2Gamerules.UpdatePregame
    function NS2Gamerules:UpdatePregame(timePassed)
        if (self:GetGameState() == kGameState.PreGame) then        
            local preGameTime = kFadedModPregameLength  
                        
            if (self.timeSinceGameStateChanged > preGameTime) then
                fadedPregameTenSecMessage = false
                fadedPregameFiveSecMessage = false
            else
                if (fadedPregameFiveSecMessage == false and floor(preGameTime - self.timeSinceGameStateChanged) == 5) then
                    Shared:FadedMessage(strformat(locale:ResolveString("FADED_GAME_STARTS_IN"), 5)) 
                    fadedPregameFiveSecMessage = true
                    fadedPregameTenSecMessage = true
                elseif (fadedPregameTenSecMessage == false and floor(preGameTime - self.timeSinceGameStateChanged) == 10) then
                    Shared:FadedMessage(strformat(locale:ResolveString("FADED_GAME_STARTS_IN"), 10))
                    fadedPregameTenSecMessage = true
                end        
            end
        end    
    
        updatePregame(self, timePassed)
    end
        
    // Hook into the update function, so we can update our mod    
    local onUpdate = NS2Gamerules.OnUpdate
    function NS2Gamerules:OnUpdate(timePassed)
        if (Server) then
            if (self:GetMapLoaded()) then
                // Update the mod
                if (self:GetGameState() == kGameState.Started) then
                    // no longer needed, as we have the GUI timer now
                    //FadedRoundTimer:UpdateRoundTimer()
                end    
            end    
        end
        
        fadedMapTime = fadedMapTime + timePassed
        
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
        
        player:FadedMessage(locale:ResolveString("FADED_WELCOME_MESSAGE_1"))
        player:FadedMessage(locale:ResolveString("FADED_WELCOME_MESSAGE_2"))
        player:FadedMessage(locale:ResolveString("FADED_WELCOME_MESSAGE_3"))
        player:FadedMessage(locale:ResolveString("FADED_WELCOME_MESSAGE_4"))
        
        Server.SendNetworkMessage(player, "RoundTime", { time = kFadedModRoundTimerInSecs }, true)
    end
    
    // Dont't let people spawn if they go to the ready room and back in game just after the game started
    function NS2Gamerules:GetCanSpawnImmediately()
        return not self:GetGameStarted() or Shared.GetCheatsEnabled() or (Shared.GetTime() < (self.gameStartTime + 0))
    end
end