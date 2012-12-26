// ===================== Hidden Mod =====================
//
// lua\HiddenAlien.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

class 'HiddenMod'

kAlienMinInnateRegeneration = 0
kAlienMaxInnateRegeneration = 0

function HiddenMod:SpawnAsFade()
    local alienTeam = GetGamerules():GetTeam2()
    if (alienTeam:GetNumPlayers() == 0) then return end
    
    local alienPlayerId = alienTeam.playerIds[1];
    player = Shared.GetEntity(alienPlayerId)
    
    local newPlayer = player:Replace(Fade.kMapName)
    newPlayer:SetCameraDistance(0)
 
    newPlayer:GiveUpgrade(kTechId.Carapace)
    newPlayer:GiveUpgrade(kTechId.Silence)
    newPlayer:GiveUpgrade(kTechId.Camouflage)
    newPlayer:GiveUpgrade(kTechId.Adrenaline)
    newPlayer:GiveUpgrade(kTechId.Celerity)
            
    local healthScalar = player:GetHealth() / player:GetMaxHealth()
    local armorScalar = player:GetMaxArmor() == 0 and 1 or player:GetArmor() / player:GetMaxArmor()

    newPlayer:SetHealth(healthScalar * LookupTechData(kTechId.Fade, kTechDataMaxHealth))
    newPlayer:SetArmor(armorScalar * LookupTechData(kTechId.Fade, kTechDataMaxArmor))
    newPlayer:UpdateArmorAmount()       
                            
    HiddenMod.hiddenPlayer = newPlayer    
end