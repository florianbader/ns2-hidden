// ===================== Faded Mod =====================
//
// lua\FadedGUIMarineBuyHelp.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local kLeapTextureName = "ui/marine_shotgun_buy.dds"

local kIconWidth = 128
local kIconHeight = 128

class 'FadedGUIMarineBuyHelp' (GUIAnimatedScript)

function FadedGUIMarineBuyHelp:Initialize()
    GUIAnimatedScript.Initialize(self)
    
    self.keyBackground = GUICreateButtonIcon("Buy")
    self.keyBackground:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    local size = self.keyBackground:GetSize()
    self.keyBackground:SetPosition(Vector(-size.x / 2, -size.y + kHelpBackgroundYOffset, 0))
    self.keyBackground:SetIsVisible(false)
    
    self.buyImage = self:CreateAnimatedGraphicItem()
    self.buyImage:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.buyImage:SetSize(Vector(kIconWidth, kIconHeight, 0))
    self.buyImage:SetPosition(Vector(-kIconWidth / 2, -kIconHeight, 0))
    self.buyImage:SetTexture(kLeapTextureName)
    self.buyImage:AddAsChildTo(self.keyBackground)
    
    self.openedBuyMenu = false
    
end

function FadedGUIMarineBuyHelp:Update(dt)

    GUIAnimatedScript.Update(self, dt)
    
    local player = Client.GetLocalPlayer()
    if player then
    
        if not self.keyBackground:GetIsVisible() then
            HelpWidgetAnimateIn(self.buyImage)
        end
        
        self.keyBackground:SetIsVisible(not self.openedBuyMenu)
    
        if not self.openedBuyMenu and player:FadedEquipmentMenuOpen() then
        
            self.openedBuyMenu = true
            HelpWidgetIncreaseUse(self, "FadedGUIMarineBuyHelp")
            player:ResetHelp()
            
        end
        
    end
    
end

function FadedGUIMarineBuyHelp:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)
    
    GUI.DestroyItem(self.keyBackground)
    self.keyBackground = nil
    
end