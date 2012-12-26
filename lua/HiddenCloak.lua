// ===================== Hidden Mod =====================
//
// lua\HiddenCloak.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

// Add three hives to the alien player
function Alien:GetHasTwoHives() return true end
function Alien:GetHasThreeHives() return true end
    
// The Hidden is always invisible, even if he's in combat
function Alien:GetIsCamouflaged() return true end
function CloakableMixin:TriggerUncloak() end
function CloakableMixin:GetCanCloak() return true end
function CloakableMixin:GetIsCloaked() return true end
function CloakableMixin:OnClampSpeed(input, velocity) end
function CloakableMixin:SetIsCloaked(_) end
function Alien:GetCelerityAllowed() return true end
    
local function UpdateCloakState(self, deltaTime)
    self.cloakChargeTime = math.max(0, self.cloakChargeTime - deltaTime)
    
    local cloakSpeedFraction = 1
    
    if self.GetSpeedScalar then
        cloakSpeedFraction = 1 - Clamp(self:GetSpeedScalar(), 0, 1)
    end
    
    if (self.cloaked or ( self.GetIsCamouflaged and self:GetIsCamouflaged() )) and self:GetCanCloak() then
        self.cloakedFraction = math.min(1, self.cloakedFraction + deltaTime * CloakableMixin.kCloakRate * cloakSpeedFraction )
    else
        self.cloakedFraction = math.max(0, self.cloakedFraction - deltaTime * CloakableMixin.kUnCloakRate )
    end
    
    // for smoother movement
    if Server then
    
        local newFullyCloaked = self.fullyCloaked
        self.fullyCloaked = self.cloakedFraction == 1
        if self.OnCloak and (newFullyCloaked ~= self.fullyCloaked) then
            self:OnCloak()
        end
        
    end    
    
end

if Server then
    function CloakableMixin:OnUpdate(deltaTime)
        UpdateCloakState(self, deltaTime)
    end

    function CloakableMixin:OnProcessMove(input)
        UpdateCloakState(self, input.time)
    end
elseif Client then

 
end    