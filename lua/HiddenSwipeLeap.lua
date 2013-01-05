// ===================== Hidden Mod =====================
//
// lua\HiddenSwipeLeap.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

Script.Load("lua/Balance.lua")
Script.Load("lua/Weapons/Alien/Ability.lua")
Script.Load("lua/Weapons/Alien/LeapMixin.lua")

class 'SwipeLeap' (Ability)

SwipeLeap.kMapName = "swipeleap"

local networkVars =
{
}

SwipeLeap.kSwipeEnergyCost = kSwipeEnergyCost
SwipeLeap.kDamage = kSwipeDamage
SwipeLeap.kRange = 1.6

local kAnimationGraph = PrecacheAsset("models/alien/fade/fade_view.animation_graph")

function SwipeLeap:OnCreate()
    Ability.OnCreate(self)
    
    InitMixin(self, LeapMixin)
    
    self.lastSwipedEntityId = Entity.invalidId
    self.primaryAttacking = false
end

function SwipeLeap:GetAnimationGraphName()
    return kAnimationGraph
end

function SwipeLeap:GetEnergyCost(player)
    return SwipeLeap.kSwipeEnergyCost
end

function SwipeLeap:GetHUDSlot()
    return 1
end

function SwipeLeap:GetPrimaryAttackRequiresPress()
    return false
end

function SwipeLeap:GetMeleeBase()
    return 1.5, 1.2
end

function SwipeLeap:GetDeathIconIndex()
    return kDeathMessageIcon.Swipe
end

function SwipeLeap:GetSecondaryTechId()
    return kTechId.Leap
end

function SwipeLeap:OnPrimaryAttack(player)

    if player:GetEnergy() >= self:GetEnergyCost() then
        self.primaryAttacking = true
    else
        self.primaryAttacking = false
    end
    
end

function SwipeLeap:OnPrimaryAttackEnd()
    
    Ability.OnPrimaryAttackEnd(self)
    
    self.primaryAttacking = false
    
end

function SwipeLeap:OnHolster(player)

    Ability.OnHolster(self, player)
    
    self.primaryAttacking = false
    
end

function SwipeLeap:OnTag(tagName)

    PROFILE("SwipeLeap:OnTag")

    if self.primaryAttacking and tagName == "start" then
    
        local player = self:GetParent()
        if player then
            player:DeductAbilityEnergy(self:GetEnergyCost())
        end
        
        self:TriggerEffects("swipe_attack")
        
    end
    
    if tagName == "hit" then
        self:PerformMeleeAttack()
    end

end

function SwipeLeap:PerformMeleeAttack()

    local player = self:GetParent()
    if player then
        local didHit, hitObject, endPoint, surface = PerformGradualMeleeAttack(self, player, SwipeLeap.kDamage, SwipeLeap.kRange)
    end
    
end

function SwipeLeap:OnUpdateAnimationInput(modelMixin)

    PROFILE("SwipeLeap:OnUpdateAnimationInput")
    
    modelMixin:SetAnimationInput("ability", "swipe")
    
    local activityString = (self.primaryAttacking and "primary") or "none"
    modelMixin:SetAnimationInput("activity", activityString)
    
end

Shared.LinkClassToMap("SwipeLeap", SwipeLeap.kMapName, networkVars)