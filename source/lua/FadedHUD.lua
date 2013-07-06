// ===================== Faded Mod =====================
//
// lua\FadedHUD.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

FadedHUD = {}

function FadedHUD:DelayHideGUIMarineHUD(script)   
    local script = ClientUI.GetScript("Hud/Marine/GUIMarineHUD") 
    
    if (script and script.commanderName) then
        script.commanderName:SetIsVisible(false)
        script.resourceDisplay.background:SetIsVisible(false)
        script.resourceDisplay.displayTeamRes = false
        script.resourceDisplay.teamText:SetIsVisible(false)
    end    
end

function FadedHUD:DelayHideGUIAlienHUD(script)
    local script = ClientUI.GetScript("GUIAlienHUD")
    
    if (script and script.resourceBackground) then
        script.resourceBackground:SetIsVisible(false)
        script.resourceDisplay.background:SetIsVisible(false)
    end 
end

function FadedHUD:DelayHideGUIBioMassDisplay(script)
    local script = ClientUI.GetScript("GUIBioMassDisplay")     
    
    if (script and script.SetIsVisible) then   
        script:SetIsVisible(false) 
    end
end

local function FadedUIScriptCreated(scriptname, script)
    FadedHUD:DelayHideGUIMarineHUD(script) 
    FadedHUD:DelayHideGUIAlienHUD(script)
    FadedHUD:DelayHideGUIBioMassDisplay(script)
end

ClientUI.AddScriptCreationEventListener(FadedUIScriptCreated)