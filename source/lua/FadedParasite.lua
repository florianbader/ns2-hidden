// ===================== Faded Mod =====================
//
// lua\FadedParasite.lua
//
//    Created by: rio (rio@myrio.de)
//
// =====================================================

kParasiteDuration = 0
/*
function ParasiteMixin:GetIsParasited()
    if (Client) then
        local player = Client.GetLocalPlayer()
        return player:isa("Alien") and player:GetDarkVisionEnabled()
    elseif (Server) then
        return true
    end
end

local function SharedUpdate(self)
    if Server then          
        self.parasited = true    
    elseif Client then
        local player = Client.GetLocalPlayer()
   
        if (player:isa("Alien") and player:GetDarkVisionEnabled()) then
            self.parasited = true
            self:_CreateParasiteEffect()
        end        
    end    
end

function ParasiteMixin:OnUpdate(deltaTime)   
    SharedUpdate(self)
end

function ParasiteMixin:OnProcessMove(input)   
    SharedUpdate(self)
end

if (Client) then
    local parasiteMixinCreateParasiteEffect = ParasiteMixin._CreateParasiteEffect
    function ParasiteMixin:_CreateParasiteEffect()
        local player = Client.GetLocalPlayer()
   
        if (player:isa("Alien") and player:GetDarkVisionEnabled()) then
            parasiteMixinCreateParasiteEffect(self)
        end    
    end
end */

if (Client) then
    function HiveVisionMixin:OnUpdate(deltaTime)  
        local player = Client.GetLocalPlayer()
        local model = self:GetRenderModel()
        
        if model ~= nil then        
            if (player:isa("Alien") and player:GetDarkVisionEnabled()) then
                HiveVision_AddModel(model)
            else
                HiveVision_RemoveModel(model)
            end
        end    
    end
end    