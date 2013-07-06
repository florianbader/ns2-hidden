// ===================== Faded Mod =====================
//
// lua\FadedPointGiverMixin.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local floor = math.floor

local pointGiverMixinGetPointValue = PointGiverMixin.GetPointValue
function PointGiverMixin:GetPointValue()
    return self:isa("Fade") 
            and kFadedModScorePointsForFadeKill
            or pointGiverMixinGetPointValue(self) 
end

local pointGiverMixinOnKill = PointGiverMixin.OnKill
function PointGiverMixin:OnKill(attacker, doer, point, direction)
    pointGiverMixinOnKill(self, attacker, doer, point, direction)
    
    // Add assist score
    if (self:isa("Fade")) then
        local damageDoneList = self.damageDoneList or {}
        
        local damageDone = 0
        for _, damage in pairs(damageDoneList) do
            damageDone = damageDone + damage   
        end
        
        local scorePerDamage = kFadedModScorePointsForFadeKill / damageDone
                
        for playerName, damage in pairs(damageDoneList) do
            local player
            for index, playerEntity in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
                if (playerEntity:GetName() == playerName) then
                    player = playerEntity
                    break
                end
            end    
        
            if (player and player ~= attacker) then                
                local score = floor(damage * scorePerDamage)
                player:AddScore(score)
            end    
        end
    end
end

function Fade:OnTakeDamage(damage, attacker, doer, point, direction, damageType)
    local damageDoneList = self.damageDoneList or {}
    local damageDoneAttacker = damageDoneList[attacker:GetName()] or 0
    
    damageDoneAttacker = damageDoneAttacker + damage
    
    damageDoneList[attacker:GetName()] = damageDoneAttacker
    self.damageDoneList = damageDoneList
end
