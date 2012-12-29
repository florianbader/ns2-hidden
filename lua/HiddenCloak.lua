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
    self.cloakedFraction = kHiddenModMaxCloakedFraction
    self.fullyCloaked = false
    
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

    function CloakableMixin:OnUpdateRender()

        PROFILE("CloakableMixin:OnUpdateRender")
        
        local player = Client.GetLocalPlayer()
    
        local newHiddenState = self:GetIsCloaked()
        local areEnemies = not GetAreEnemies(self, player)
        if self.clientCloaked ~= newHiddenState then
        
            if self.clientCloaked ~= nil then
                self:TriggerEffects("client_cloak_changed", {cloaked = newHiddenState, enemy = areEnemies})
            end
            self.clientCloaked = newHiddenState

        end
        
        // cloaked aliens off infestation are not 100% hidden
        local speedScalar = 0
        
        if self.GetVelocityLength then
            speedScalar = self:GetVelocityLength() / 3
        end
             
        self:SetOpacity(1-self.cloakedFraction, "cloak")

        if self == player then
        
            local viewModelEnt = self:GetViewModelEntity()            
            if viewModelEnt then
                viewModelEnt:SetOpacity(1-self.cloakedFraction, "cloak")
            end
        
        end
        
        local showMaterial = not areEnemies
        local model = self:GetRenderModel()
    
        if model then

            if showMaterial then
                
                if not self.cloakedMaterial then
                    self.cloakedMaterial = AddMaterial(model, "cinematics/vfx_materials/cloaked.material")
                end
                
                self.cloakedMaterial:SetParameter("cloakAmount", self.cloakedFraction)   
            
            else
            
                if self.cloakedMaterial then
                    RemoveMaterial(model, self.cloakedMaterial)
                    self.cloakedMaterial = nil
                end
            
            end
            
            if self == player then
                
                local viewModelEnt = self:GetViewModelEntity()
                if viewModelEnt and viewModelEnt:GetRenderModel() then
                
                    if not self.cloakedViewMaterial then
                        self.cloakedViewMaterial = AddMaterial(viewModelEnt:GetRenderModel(), "cinematics/vfx_materials/cloaked.material")
                    end
                    
                    self.cloakedViewMaterial:SetParameter("cloakAmount", self.cloakedFraction)
                    
                end
                
            end
            
        end    
 
    end
    
end    