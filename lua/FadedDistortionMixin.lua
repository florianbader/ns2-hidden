// ===================== Faded Mod =====================
//
// lua\FadedDistortionMixin.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

DistortionMixin = CreateMixin(DistortionMixin)
DistortionMixin.type = "Distortion"

DistortionMixin.expectedCallbacks = {}

// don't update too often
DistortionMixin.kUpdateIntervall = 0.5
DistortionMixin.kDistortionIntensity = 12

DistortionMixin.expectedMixins =
{
}    

DistortionMixin.networkVars =
{
}

function DistortionMixin:__initmixin()
    self.distortionAmount = 0
    self.timeLastDistortionUpdate = 0
end

local function SharedUpdate(self)
    if self.timeLastDistortionUpdate + DistortionMixin.kUpdateIntervall < Shared.GetTime() then    
        local fromPoint = self:GetOrigin()
        local nearbyFade = GetEntitiesWithinRange("Fade", fromPoint, kFadedModDistortionRadius)
        
        local adjustedDistortion = false
        
        for _, fade in ipairs(nearbyFade) do    
            local distanceToFade = (fade:GetOrigin() - fromPoint):GetLength()
            self.distortionAmount = DistortionMixin.kDistortionIntensity - Clamp( (distanceToFade / kFadedModDistortionRadius) * DistortionMixin.kDistortionIntensity, 0, DistortionMixin.kDistortionIntensity)
            adjustedDistortion = true  
            break        
        end
        
        if not adjustedDistortion then
            self.distortionAmount = 0
        end
    
        self.timeLastDistortionUpdate = Shared.GetTime()        
    end
end

function DistortionMixin:OnProcessMove(input)
    SharedUpdate(self)
end

function DistortionMixin:OnUpdate(deltaTime)
    SharedUpdate(self)
end

function DistortionMixin:GetDistortionAmount()
    return self.distortionAmount
end
