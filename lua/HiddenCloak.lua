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
//function Alien:GetIsCamouflaged() return true end
function CloakableMixin:TriggerUncloak() end
//function CloakableMixin:GetCanCloak() return true end
function CloakableMixin:GetIsCloaked() return true end
function CloakableMixin:OnClampSpeed(input, velocity) end
//function CloakableMixin:SetIsCloaked(_) end
function Alien:GetCelerityAllowed() return true end

if Client then

    function CloakableMixin:OnUpdateRender()

        PROFILE("CloakableMixin:OnUpdateRender")
        
        local player = Client.GetLocalPlayer()
        
        local opacity = self:GetIsAlive() and 0 or 1
        local cloakAmount = self:GetIsAlive() and 1-kHiddenModMaxCloakedFraction or 0            
          
        self:SetOpacity(opacity, "cloak")
        
        if self == player then   
            cloakAmount = 1
         
            local viewModelEnt = self:GetViewModelEntity()            
            if viewModelEnt then
                viewModelEnt:SetOpacity(opacity, "cloak")
            end
        
        end
        
        local showMaterial = not areEnemies
        local model = self:GetRenderModel()
    
        if model then      
            if not self.cloakedMaterial then
                self.cloakedMaterial = AddMaterial(model, "cinematics/vfx_materials/cloaked.material")
            end
            
            self.cloakedMaterial:SetParameter("cloakAmount", cloakAmount) 
            
            if self == player then
                
                local viewModelEnt = self:GetViewModelEntity()
                if viewModelEnt and viewModelEnt:GetRenderModel() then
                
                    if not self.cloakedViewMaterial then
                        self.cloakedViewMaterial = AddMaterial(viewModelEnt:GetRenderModel(), "cinematics/vfx_materials/cloaked.material")
                    end
                    
                    self.cloakedViewMaterial:SetParameter("cloakAmount", cloakAmount)
                    
                end
                
            end
            
        end    
 
    end
    
    function CloakableMixin:OnGetIsVisible(visibleTable)

        local player = Client.GetLocalPlayer()    

        if self:GetIsCloaked() and GetAreEnemies(self, player) then
            visibleTable.Visible = true
        end    
        
    end
    
end    