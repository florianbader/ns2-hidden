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
        return (teamNumber ~= 2)
    end
    
    // Only allow players to join the marine team
    local joinTeam = NS2Gamerules.JoinTeam    
    function NS2Gamerules:JoinTeam(player, newTeamNumber, force)
        if (newTeamNumber == 2 and not force) then
            Shared:HiddenMessagePrivate("You can't join the Alien team. The Hidden will be chosen randomly among all players.", player)
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
            
            if (team1Players == 1 and Shared.GetTime() - (hiddenModLastTimeTwoPlayersToStartMessage or 0) > kHiddenModTwoPlayerToStartMessage) then
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
                Shared:HiddenMessage(string.format("%s is now the Hidden.", player:GetName()))
                Shared:HiddenMessageMarines("Your objective is: Kill the Hidden before the time runs out... or he kills you.")
                Shared:HiddenMessageMarines("Watch where you shoot, friendly fire is on!")
                Shared:HiddenMessageHidden("Your objective is: Kill all Marines!")
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
                if (hiddenPregameFiveSecMessage == false and math.floor(preGameTime - self.timeSinceGameStateChanged) == 5) then
                    Shared:HiddenMessage("Game starts in 5...") 
                    hiddenPregameFiveSecMessage = true
                    hiddenPregameTenSecMessage = true
                elseif (hiddenPregameTenSecMessage == false and math.floor(preGameTime - self.timeSinceGameStateChanged) == 10) then
                    Shared:HiddenMessage("Game starts in 10...")
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
    
    // Welcome message!
    local onClientConnect = Player.OnClientConnect
    function Player:OnClientConnect(client)
        onClientConnect(self, client)
        
        local player = client:GetControllingPlayer()
        Shared:HiddenMessage("wat wat")
        Shared:HiddenMessagePrivate(string.Format("Welcome %s. You are playing the Natural Selection 2: Hidden Mod.", self:GetName()), self)
        Shared:HiddenMessagePrivate("In this mod there are Marines and the Hidden. You can only join the Marines while the Hidden is chosen randomly.", self)
        Shared:HiddenMessagePrivate("The Marines have to kill the Hidden and the Hidden has to kill all Marines.", self)
        Shared:HiddenMessagePrivate("But be careful, the Hidden is fast, strong and invisible!", self)
    end
end