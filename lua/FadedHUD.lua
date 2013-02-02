// ===================== Faded Mod =====================
//
// lua\FadedHUD.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local function OnLoadComplete()
    local guiMarineHUDInitialize = GUIMarineHUD.Initialize
    function GUIMarineHUD:Initialize()
        guiMarineHUDInitialize(self)
        
        // Hide commander name
        self.commanderName:SetIsVisible(false)
    end

    local guiPlayerResourceInitialize = GUIPlayerResource.Initialize
    function GUIPlayerResource:Initialize(style) 
        guiPlayerResourceInitialize(self, style)
        
        // Hide player resources
        self.background:SetIsVisible(false)
        
        // Hide team res
        self.teamText:SetIsVisible(false)
    end
end    


Event.Hook("LoadComplete", OnLoadComplete)