// ===================== Hidden Mod =====================
//
// lua\HiddenFade_Server.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

function Fade:InitWeapons()
    Alien.InitWeapons(self)
    
    self:GiveItem(SwipeLeap.kMapName)
    self:SetActiveWeapon(SwipeLeap.kMapName)    
end

function Fade:GetTierTwoTechId()
    return kTechId.None //Stab
end

function Fade:GetTierThreeTechId()
    return kTechId.None
end