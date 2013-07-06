// ===================== Faded Mod =====================
//
// lua\FadedLights.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local lastShutdownLights = nil
function ShutdownLights()
    if (lastShutdownLights and (Shared.GetTime() - lastShutdownLights) < 2) then return end
    lastShutdownLights = Shared.GetTime()
    
    local color = Color(kFadedModLightColorScale, kFadedModLightColorScale, kFadedModLightColorScale)
    
    for index, renderLight in ipairs(Client.lightList) do
        renderLight:SetIntensity(kFadedModLightIntensity)    
        renderLight:SetColor(color)
        
        if renderLight:GetType() == RenderLight.Type_AmbientVolume then            
            renderLight:SetDirectionalColor(RenderLight.Direction_Right,    color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Left,     color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Up,       color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Down,     color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Forward,  color)
            renderLight:SetDirectionalColor(RenderLight.Direction_Backward, color)                
        end 
    end    
end

Event.Hook("UpdateClient", ShutdownLights)

// Dont't reset the scoreboard on game reset
function OnCommandOnResetGame()
    ResetLights()
end