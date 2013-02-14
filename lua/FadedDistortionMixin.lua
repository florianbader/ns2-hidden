// ===================== Faded Mod =====================
//
// lua\FadedDistortionMixin.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local pow = math.pow

DistortionMixin = CreateMixin(DistortionMixin)
DistortionMixin.type = "Distortion"

DistortionMixin.expectedCallbacks = {}

// don't update too often
DistortionMixin.kUpdateIntervall = 0.5

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
            if (fade:GetIsAlive()) then
                local distanceToFade = (fade:GetOrigin() - fromPoint):GetLength()
                
                self.distortionAmount = kFadedModDistortionIntensity - 
                    Clamp( (pow(distanceToFade / kFadedModDistortionRadius, kFadedModDistortionAcceleration)) * kFadedModDistortionIntensity, 
                    0, kFadedModDistortionIntensity)
                    
                adjustedDistortion = true  
                break   
            end     
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
