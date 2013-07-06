// ===================== Faded Mod =====================
//
// lua\FadedGUIFadeLeapHelp.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local kLeapTextureName = "ui/skulk_jump.dds"

local kIconWidth = 128
local kIconHeight = 128

class 'FadedGUIFadeLeapHelp' (GUIAnimatedScript)

function FadedGUIFadeLeapHelp:Initialize()

    GUIAnimatedScript.Initialize(self)
    
    self.keyBackground = GUICreateButtonIcon("SecondaryAttack")
    self.keyBackground:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    local size = self.keyBackground:GetSize()
    self.keyBackground:SetPosition(Vector(-size.x / 2, -size.y + kHelpBackgroundYOffset, 0))
    self.keyBackground:SetIsVisible(false)
    
    self.leapImage = self:CreateAnimatedGraphicItem()
    self.leapImage:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.leapImage:SetSize(Vector(kIconWidth, kIconHeight, 0))
    self.leapImage:SetPosition(Vector(-kIconWidth / 2, -kIconHeight, 0))
    self.leapImage:SetTexture(kLeapTextureName)
    self.leapImage:AddAsChildTo(self.keyBackground)
    
end

function FadedGUIFadeLeapHelp:Update(dt)

    GUIAnimatedScript.Update(self, dt)
    
    local player = Client.GetLocalPlayer()
    if player then
    
        if not self.leaped and player:GetIsLeaping() then
        
            self.leaped = true
            HelpWidgetIncreaseUse(self, "FadedGUIFadeLeapHelp")
            
            // Show the next help widget, because the player doesn't play that often as Fade,
            // so he gets all the abilities playing a Fade for the first time
            player:ResetHelp()
            player:AddHelpWidget("FadedGUIFadeWallgripHelp", kFadedModGUIHelpLimit)
            
        end
        
        local activeWeapon = player:GetActiveWeapon()
        local displayLeap = not self.leaped and activeWeapon and activeWeapon:GetHasSecondary(player)
        
        if not self.keyBackground:GetIsVisible() and displayLeap then
            HelpWidgetAnimateIn(self.leapImage)
        end
        
        self.keyBackground:SetIsVisible(displayLeap == true)
        
    end
    
end

function FadedGUIFadeLeapHelp:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)
    
    GUI.DestroyItem(self.keyBackground)
    self.keyBackground = nil
    
end