// ===================== Hidden Mod =====================
//
// lua\HiddenSwipeBlink.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

Script.Load("lua/Balance.lua")
Script.Load("lua/Weapons/Alien/Ability.lua")
Script.Load("lua/Weapons/Alien/LeapMixin.lua")

class 'SwipeBlink' (Ability)

SwipeBlink.kMapName = "swipe"

local networkVars =
{
}

kLeapEnergyCost = 20

SwipeBlink.kSwipeEnergyCost = kSwipeEnergyCost
SwipeBlink.kDamage = kSwipeDamage
SwipeBlink.kRange = 1.6

local kAnimationGraph = PrecacheAsset("models/alien/fade/fade_view.animation_graph")

function SwipeBlink:OnCreate()
    Ability.OnCreate(self)
    
    InitMixin(self, LeapMixin)
    
    self.lastSwipedEntityId = Entity.invalidId
    self.primaryAttacking = false
end

function SwipeBlink:GetAnimationGraphName()
    return kAnimationGraph
end

function SwipeBlink:GetEnergyCost(player)
    return SwipeBlink.kSwipeEnergyCost
end

function SwipeBlink:GetHUDSlot()
    return 1
end

function SwipeBlink:GetPrimaryAttackRequiresPress()
    return false
end

function SwipeBlink:GetMeleeBase()
    return 1.5, 1.2
end

function SwipeBlink:GetDeathIconIndex()
    return kDeathMessageIcon.Swipe
end

function SwipeBlink:GetSecondaryTechId()
    return kTechId.Leap
end

function SwipeBlink:OnPrimaryAttack(player)

    if player:GetEnergy() >= self:GetEnergyCost() then
        self.primaryAttacking = true
    else
        self.primaryAttacking = false
    end
    
end

function SwipeBlink:OnPrimaryAttackEnd()
    
    Ability.OnPrimaryAttackEnd(self)
    
    self.primaryAttacking = false
    
end

function SwipeBlink:OnHolster(player)

    Ability.OnHolster(self, player)
    
    self.primaryAttacking = false
    
end

function SwipeBlink:OnTag(tagName)

    PROFILE("SwipeBlink:OnTag")

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

function SwipeBlink:PerformMeleeAttack()

    local player = self:GetParent()
    if player then
        local didHit, hitObject, endPoint, surface = PerformGradualMeleeAttack(self, player, SwipeBlink.kDamage, SwipeBlink.kRange)
    end
    
end

function SwipeBlink:OnUpdateAnimationInput(modelMixin)

    PROFILE("SwipeBlink:OnUpdateAnimationInput")
    
    modelMixin:SetAnimationInput("ability", "swipe")
    
    local activityString = (self.primaryAttacking and "primary") or "none"
    modelMixin:SetAnimationInput("activity", activityString)
    
end

// We don't need shadow step when we can leap
function SwipeBlink:GetCanShadowStep()
    return false
end    

Shared.LinkClassToMap("SwipeBlink", SwipeBlink.kMapName, networkVars)