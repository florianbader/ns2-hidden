// ===================== Faded Mod =====================
//
// lua\FadedClient.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

// Load the ns2 client script
Script.Load("lua/Client.lua")

// Load faded mod client scripts
Script.Load("lua/FadedShared.lua")
Script.Load("lua/FadedHUD.lua")
Script.Load("lua/FadedHelpMixin.lua")

// Only include the Test script in the development version
if (kFadedModVersion:lower():find("development")) then
    Script.Load("lua/FadedTest.lua")
end    

function PowerPoint:UpdatePoweredLights()
    local color = Color(0.2, 0.2, 0.2)
    
    for _, renderLight in ipairs(GetLightsForLocation(self:GetLocationName())) do
        renderLight:SetIntensity(0.2)    
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

Client.HookNetworkMessage("ResetGame", function() UpdatePowerPointLights() end)