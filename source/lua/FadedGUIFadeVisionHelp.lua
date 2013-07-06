// ===================== Faded Mod =====================
//
// lua\FadedGUIFadeVisionHelp.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local kVisionTextureName = "ui/alien_night_vision.dds"

local kIconHeight = 128
local kIconWidth = 128

class 'FadedGUIFadeVisionHelp' (GUIAnimatedScript)

function FadedGUIFadeVisionHelp:Initialize()

    GUIAnimatedScript.Initialize(self)
    
    self.keyBackground = GUICreateButtonIcon("ToggleFlashlight")
    self.keyBackground:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    local size = self.keyBackground:GetSize()
    self.keyBackground:SetPosition(Vector(-size.x / 2, -size.y + kHelpBackgroundYOffset, 0))
    self.keyBackground:SetIsVisible(false)
    
    self.visionImage = self:CreateAnimatedGraphicItem()
    self.visionImage:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.visionImage:SetSize(Vector(kIconWidth, kIconHeight, 0))
    self.visionImage:SetPosition(Vector(-kIconWidth / 2, -kIconHeight, 0))
    self.visionImage:SetTexture(kVisionTextureName)
    self.visionImage:AddAsChildTo(self.keyBackground)
    
end

function FadedGUIFadeVisionHelp:Update(dt)

    GUIAnimatedScript.Update(self, deltaTime)
            
    local helpVisible = false
  
    local player = Client.GetLocalPlayer()   
    if player then
            
        // Only show the vision help widget, if marines are within range,
        // so the player can see, that the Fade can see marines through walls in dark vision.       
        local marines = GetEntitiesWithinRange("Marine", player:GetOrigin(), 25)
        
        if (not self.alienVisionUsed and #marines > 0) then
    
            if player:GetDarkVisionEnabled() then
                self.keyBackground:SetIsVisible(false)
                self.alienVisionUsed = true
                HelpWidgetIncreaseUse(self, "FadedGUIFadeVisionHelp")
                player:ResetHelp()            
            else
                helpVisible = true    
            end
                        
        end    
        
    end    
    
    if not self.keyBackground:GetIsVisible() and helpVisible then
        HelpWidgetAnimateIn(self.visionImage)
    end
    
    self.keyBackground:SetIsVisible(helpVisible)
    
end

function FadedGUIFadeVisionHelp:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)
    
    GUI.DestroyItem(self.keyBackground)
    self.keyBackground = nil
    
end