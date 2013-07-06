 // ===================== Faded Mod =====================
//
// lua\FadedFade_Client.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

Player.screenEffects.fadeVision = Client.CreateScreenEffect("shaders/FadeVision.screenfx")
Player.screenEffects.fadeVision:SetActive(false)

local fadeUpdateClientEffects = Fade.UpdateClientEffects
function Fade:UpdateClientEffects(deltaTime, isLocal)
    if (not Client.GetLocalPlayer():isa("Fade")) then return end

    fadeUpdateClientEffects(self, deltaTime, isLocal)

    Player.screenEffects.fadeVision:SetActive(not self:GetDarkVisionEnabled())  
    
    if Player.screenEffects.fadeVision then            
        Player.screenEffects.fadeVision:SetParameter("startTime", Shared.GetTime())
        Player.screenEffects.fadeVision:SetParameter("time", Shared.GetTime())
        Player.screenEffects.fadeVision:SetParameter("amount", 0)        
    end
end