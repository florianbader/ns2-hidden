// ===================== Hidden Mod =====================
//
// lua\HiddenGamerules.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

local hiddenPlayer = nil
local hiddenPregameTenSecMessage = false
local hiddenPregameFiveSecMessage = false
local hiddenModLastTimeTwoPlayersToStartMessage = nil

if Server then  
    // Checks if the hidden is dead
    function NS2Gamerules:CheckIfHiddenIsDead()
        return (self.team2:GetNumDeadPlayers() == self.team2:GetNumPlayers())   
    end
    
    // Checks if the marines are dead
    function NS2Gamerules:CheckIfMarinesAreDead()
        return (self.team1:GetNumDeadPlayers() == self.team1:GetNumPlayers())   
    end

    // Only allow players to join the marine team
    function NS2Gamerules:GetCanJoinTeamNumber(teamNumber)
        return not (teamNumber == 2)
    end
    
    // Only allow players to join the marine team
    local joinTeam = NS2Gamerules.JoinTeam    
    function NS2Gamerules:JoinTeam(player, newTeamNumber, force)
        if (newTeamNumber == 2 and not force) then
            return false, player
        end

        return joinTeam(self, player, newTeamNumber, force) 
    end
    
    // Define the game ending rules
    function NS2Gamerules:CheckGameEnd()    
        if (self:GetGameStarted() and self.timeGameEnded == nil and not self.preventGameEnd) then        
            if (self.timeLastGameEndCheck == nil or (Shared.GetTime() > self.timeLastGameEndCheck + 1)) then
                local team1Players = self.team1:GetNumPlayers()
                local team2Players = self.team2:GetNumPlayers()
                
                if (team1Players == 0) then
                    Shared:HiddenMessage("No Marines left. The Hidden wins!")
                    self:EndGame(self.team2)
                elseif (team2Players == 0) then
                    Shared:HiddenMessage("The Hidden left. The Marines win!")
                    self:EndGame(self.team1)    
                elseif (self:CheckIfHiddenIsDead() == true) then
                    Shared:HiddenMessage("The Hidden is dead. The Marines win!")
                    self:EndGame(self.team1)
                elseif (self:CheckIfMarinesAreDead() == true) then                
                    Shared:HiddenMessage("All Marines are dead. The Hidden wins!")
                    self:EndGame(self.team2)
                elseif (HiddenRoundTimer:GetIsRoundTimeOver()) then       
                    Shared:HiddenMessage("The Hidden escaped. The Hidden wins!")
                    self:EndGame(self.team2)
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
            
            if (team1Players <= 1 and Shared.GetTime() - (hiddenModLastTimeTwoPlayersToStartMessage or 0) > kHiddenModTwoPlayerToStartMessage) then
                Shared:HiddenMessage("The game won't start until there are two players.")
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
            local player = Shared:GetRandomPlayer(self.team1.playerIds)
            
            if (player) then
                Shared:HiddenMessage(string.format("%s is now the Hidden.", player:GetName()))
                
                // Switch the Hidden to the alien team and give him some upgrades!
                self:JoinTeam(player, 2, true)  
                HiddenMod:SpawnAsFade()
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
            if self.timeSinceGameStateChanged >= kHiddenModTimeTillNewRound then                                
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
                if (hiddenPregameFiveSecMessage == false and preGameTime - self.timeSinceGameStateChanged < 5 and preGameTime - self.timeSinceGameStateChanged > 4) then
                    Shared:HiddenMessage("Game starts in 5...") 
                    hiddenPregameFiveSecMessage = true
                    hiddenPregameTenSecMessage = true
                elseif (hiddenPregameTenSecMessage == false and preGameTime - self.timeSinceGameStateChanged < 10 and preGameTime - self.timeSinceGameStateChanged > 9) then
                    Shared:HiddenMessage("Game starts in 10...")
                    hiddenPregameTenSecMessage = true
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
                    HiddenRoundTimer:UpdateRoundTimer()
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
end