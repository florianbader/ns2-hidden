// ===================== Faded Mod =====================
//
// lua\FadedRagdoll.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

function Ragdoll:OnUpdateRender() end
function Ragdoll:TimeUp() end

local function SetRagdoll(self, deathTime)
    if Server then    
        if self:GetPhysicsGroup() ~= PhysicsGroup.RagdollGroup then        
            self:SetPhysicsType(PhysicsType.Dynamic)            
            self:SetPhysicsGroup(PhysicsGroup.RagdollGroup)
            
            // Apply landing blow death impulse to ragdoll (but only if we didn't play death animation).
            if self.deathImpulse and self.deathPoint and self:GetPhysicsModel() and self:GetPhysicsType() == PhysicsType.Dynamic then            
                self:GetPhysicsModel():AddImpulse(self.deathPoint, self.deathImpulse)
                self.deathImpulse = nil
                self.deathPoint = nil
                self.doerClassName = nil                
            end
            
            if deathTime then
                self.timeToDestroy = deathTime
            end            
        end        
    end    
end

if (Server) then
    function RagdollMixin:OnTag(tagName)
        if not self.GetHasClientModel or not self:GetHasClientModel() then        
            if tagName == "death_end" then            
                if self.bypassRagdoll then
                    //self:SetModel(nil)
                else
                    //SetRagdoll(self)
                end                
            elseif tagName == "destroy" then
                //DestroyEntitySafe(self)
            end            
        end
    end
end    

function RagdollMixin:OnKill(attacker, doer, point, direction)
end

local createRagdoll = CreateRagdoll
function CreateRagdoll(fromEntity)
end