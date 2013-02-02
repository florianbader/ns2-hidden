// ===================== Faded Mod =====================
//
// lua\FadedGUIFadeWallgripHelp.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local kLeapTextureName = "ui/skulk_jump.dds"
local kWallgripTextureName = "ui/lerk_roost.dds"

local kIconWidth = 128
local kIconHeight = 128

class 'FadedGUIFadeWallgripHelp' (GUIAnimatedScript)

function FadedGUIFadeWallgripHelp:Initialize()

    GUIAnimatedScript.Initialize(self)
    
    self.keyBackground = GUICreateButtonIcon("MovementModifier")
    self.keyBackground:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    local size = self.keyBackground:GetSize()
    self.keyBackground:SetPosition(Vector(-size.x / 2, -size.y + kHelpBackgroundYOffset, 0))
    self.keyBackground:SetIsVisible(false)
            
    self.wallgripImage = self:CreateAnimatedGraphicItem()
    self.wallgripImage:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.wallgripImage:SetSize(Vector(kIconWidth, kIconHeight, 0))
    self.wallgripImage:SetPosition(Vector(-kIconWidth / 2, -kIconHeight, 0))
    self.wallgripImage:SetTexture(kWallgripTextureName)
    self.wallgripImage:AddAsChildTo(self.keyBackground)
    
end

function FadedGUIFadeWallgripHelp:Update(dt)

    GUIAnimatedScript.Update(self, dt)
    
    local player = Client.GetLocalPlayer()
    if player then
    
        if not self.wallgripped and player:GetIsWallGripping() then
        
            self.wallgripped = true
            HelpWidgetIncreaseUse(self, "FadedGUIFadeWallgripHelp")
            
            // Show the next help widget, because the player doesn't play that often as Fade,
            // so he gets all the abilities playing a Fade for the first time
            player:ResetHelp()
            player:AddHelpWidget("FadedGUIFadeVisionHelp", kFadedModGUIHelpLimit)
            
        end        
        
        if not self.wallgripImage:GetIsVisible() then
            HelpWidgetAnimateIn(self.wallgripImage)
        end
        
        if not self.wallgripped and player:GetIsLeaping() then
            self.keyBackground:SetIsVisible(true)
        else
            self.keyBackground:SetIsVisible(false)
        end
        
    end
    
end

function FadedGUIFadeWallgripHelp:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)
    
    GUI.DestroyItem(self.keyBackground)
    self.keyBackground = nil
    
end