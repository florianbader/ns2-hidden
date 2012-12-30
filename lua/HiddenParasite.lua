// ===================== Hidden Mod =====================
//
// lua\HiddenParasite.lua
//
//    Created by: rio (rio@myrio.de)
//
// ======================================================

kParasiteDuration = 0

function ParasiteMixin:GetIsParasited()
    if (Client) then
        local player = Client.GetLocalPlayer()
        return player:isa("Alien") and player:GetDarkVisionEnabled()
    elseif (Server) then
        return false
    end
end

local function SharedUpdate(self)
    if Server then          
        //self.parasited = true    
    elseif Client and not Shared.GetIsRunningPrediction() then 
        local player = Client.GetLocalPlayer()
   
        if (player:isa("Alien") and player:GetDarkVisionEnabled()) then
            self.parasited = true
            self:_CreateParasiteEffect()
        elseif (player:isa("Alien") and not player:GetDarkVisionEnabled()) then
            self.parasited = false 
            self:_RemoveParasiteEffect()
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
end