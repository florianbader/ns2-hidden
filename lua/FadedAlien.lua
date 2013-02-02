// ===================== Faded Mod =====================
//
// lua\FadedAlien.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local locale = LibCache:GetLibrary("LibLocales-1.0")

class 'FadedMod'

kAlienMinInnateRegeneration = 0
kAlienMaxInnateRegeneration = 0

function FadedMod:SpawnAsFade()
    local alienTeam = GetGamerules():GetTeam2()
    if (alienTeam:GetNumPlayers() == 0) then return end
    
    local marineTeam = GetGamerules():GetTeam1()
    local marineTeamPlayerCount = marineTeam:GetNumPlayers()
    
    for _, alienPlayerId in pairs(alienTeam.playerIds) do
        player = Shared.GetEntity(alienPlayerId)
        
        local newPlayer = player:Replace(Fade.kMapName)
        //newPlayer:SetCameraDistance(0)
     
        newPlayer:GiveUpgrade(kTechId.Carapace)
        newPlayer:GiveUpgrade(kTechId.Silence)
        newPlayer:GiveUpgrade(kTechId.Camouflage)
        newPlayer:GiveUpgrade(kTechId.Adrenaline)
        newPlayer:GiveUpgrade(kTechId.Celerity)
        
        local playerCountHandicap = marineTeamPlayerCount > kFadedModMaxMarinePlayersUntilFadeScale 
                and marineTeamPlayerCount / kFadedModMaxMarinePlayersUntilFadeScale 
                or 1
        
        newPlayer:SetMaxHealth(playerCountHandicap * LookupTechData(kTechId.Fade, kTechDataMaxHealth))
        newPlayer:SetHealth(playerCountHandicap * LookupTechData(kTechId.Fade, kTechDataMaxHealth))
        newPlayer:SetMaxArmor(playerCountHandicap * LookupTechData(kTechId.Fade, kTechDataMaxArmor))
        newPlayer:SetArmor(playerCountHandicap * LookupTechData(kTechId.Fade, kTechDataMaxArmor))
    end 
end

local playerOnKill = Player.OnKill
function Player:OnKill(attacker, doer, point, direction)
    playerOnKill(self, attacker, doer, point, direction)
    
    // The player who killed the Faded has a higher chance to be the Faded next round
    if (self:GetTeamNumber() == 2 and attacker and attacker:isa("Marine")) then
        fadedNextPlayer = attacker:GetName()
        attacker:FadedMessage(locale:ResolveString("FADED_SELECTION_MARINE"))
    end    
end