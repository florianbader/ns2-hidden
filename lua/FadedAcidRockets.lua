// ===================== Faded Mod =====================
//
// lua\FadedAcidRockets.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

Script.Load("lua/Weapons/Alien/LeapMixin.lua")

local floor = math.floor

local networkVars =
{
    firingPrimary = "boolean"
}

AddMixinNetworkVars(LeapMixin, networkVars)

function BileBomb:OnCreate()
    Ability.OnCreate(self)
    
    self.firingPrimary = false
    self.timeLastBileBomb = kFadedModBombFireRateinSeconds
    
    InitMixin(self, LeapMixin)    
end

function BileBomb:GetHUDSlot()
    return 2
end

function BileBomb:GetSecondaryTechId()
    return kTechId.Leap
end

function BileBomb:GetEnergyCost(player)
    return kFadedModAcidRocketsEnergyCost
end

function BileBomb:OnPrimaryAttack(player)
    local lastBileBomb = self:GetTimeLastBomb()
    if (lastBileBomb ~= 0) then
        lastBileBomb = Shared.GetTime() - lastBileBomb
    end
    
    if player:GetEnergy() >= self:GetEnergyCost() and lastBileBomb >= kFadedModBombFireRateinSeconds then    
        self.firingPrimary = true        
    else
        self.firingPrimary = false
    end      
end

function BileBomb:FireBombProjectile(player)

    PROFILE("BileBomb:FireBombProjectile")
    
    if Server then
    
        local viewAngles = player:GetViewAngles()
        local viewCoords = viewAngles:GetCoords()
        local startPoint = player:GetEyePos() + viewCoords.zAxis * 1
        
        local startPointTrace = Shared.TraceRay(player:GetEyePos(), startPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterOne(player))
        startPoint = startPointTrace.endPoint
        
        local startVelocity = viewCoords.zAxis * kFadedModBombVelocity
        
        local bomb = CreateEntity(Bomb.kMapName, startPoint, player:GetTeamNumber())
        bomb:Setup(player, startVelocity, true)
        
    end
    
end

// We don't need shadow step when we can leap
function BileBomb:GetCanShadowStep()
    return false
end   

Shared.LinkClassToMap("BileBomb", BileBomb.kMapName, networkVars)