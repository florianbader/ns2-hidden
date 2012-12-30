// ===================== Hidden Mod =====================
//
// lua\HiddenGUIMarineEquipmentMenu.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

Script.Load("lua/GUIAnimatedScript.lua")

class 'HiddenGUIMarineEquipmentMenu' (GUIAnimatedScript)

HiddenGUIMarineEquipmentMenu.kBuyMenuTexture = "ui/marine_buy_textures.dds"
HiddenGUIMarineEquipmentMenu.kBuyHUDTexture = "ui/marine_buy_icons.dds"
HiddenGUIMarineEquipmentMenu.kRepeatingBackground = "ui/menu/grid.dds"
HiddenGUIMarineEquipmentMenu.kContentBgTexture = "ui/menu/repeating_bg.dds"
HiddenGUIMarineEquipmentMenu.kContentBgBackTexture = "ui/menu/repeating_bg_black.dds"
HiddenGUIMarineEquipmentMenu.kResourceIconTexture = "ui/pres_icon_big.dds"
HiddenGUIMarineEquipmentMenu.kBigIconTexture = "ui/marine_buy_bigicons.dds"
HiddenGUIMarineEquipmentMenu.kButtonTexture = "ui/marine_buymenu_button.dds"
HiddenGUIMarineEquipmentMenu.kMenuSelectionTexture = "ui/marine_buymenu_selector.dds"
HiddenGUIMarineEquipmentMenu.kScanLineTexture = "ui/menu/scanLine_big.dds"
HiddenGUIMarineEquipmentMenu.kArrowTexture = "ui/menu/arrow_horiz.dds"

HiddenGUIMarineEquipmentMenu.kFont = "fonts/AgencyFB_small.fnt"
HiddenGUIMarineEquipmentMenu.kFont2 = "fonts/AgencyFB_small.fnt"

HiddenGUIMarineEquipmentMenu.kDescriptionFontName = "MicrogrammaDBolExt"
HiddenGUIMarineEquipmentMenu.kDescriptionFontSize = GUIScale(20)

HiddenGUIMarineEquipmentMenu.kScanLineHeight = GUIScale(256)
HiddenGUIMarineEquipmentMenu.kScanLineAnimDuration = 5

HiddenGUIMarineEquipmentMenu.kArrowWidth = GUIScale(32)
HiddenGUIMarineEquipmentMenu.kArrowHeight = GUIScale(32)
HiddenGUIMarineEquipmentMenu.kArrowTexCoords = { 1, 1, 0, 0 }

HiddenGUIMarineEquipmentMenu.kSmallIconSize = GUIScale( Vector(100, 50, 0) )
HiddenGUIMarineEquipmentMenu.kMenuIconSize = GUIScale( Vector(190, 80, 0) )
HiddenGUIMarineEquipmentMenu.kSelectorSize = GUIScale( Vector(215, 110, 0) )
HiddenGUIMarineEquipmentMenu.kIconTopOffset = 10
HiddenGUIMarineEquipmentMenu.kItemIconYOffset = {}

HiddenGUIMarineEquipmentMenu.kEquippedIconTopOffset = 58

HiddenGUIMarineEquipmentMenu.kBackgroundWidth = GUIScale(600)
HiddenGUIMarineEquipmentMenu.kBackgroundHeight = GUIScale(520)

local smallIconHeight = 64
local smallIconWidth = 128
local gSmallIconIndex = nil
local function GetSmallIconPixelCoordinates(itemTechId)

    if not gSmallIconIndex then
    
        gSmallIconIndex = {}
        gSmallIconIndex[kTechId.Axe] = 4
        gSmallIconIndex[kTechId.Pistol] = 3
        gSmallIconIndex[kTechId.Rifle] = 1
        gSmallIconIndex[kTechId.Shotgun] = 5
        gSmallIconIndex[kTechId.GrenadeLauncher] = 8
        gSmallIconIndex[kTechId.Flamethrower] = 6
        gSmallIconIndex[kTechId.Jetpack] = 24
        gSmallIconIndex[kTechId.Exosuit] = 25
        gSmallIconIndex[kTechId.Welder] = 10
        gSmallIconIndex[kTechId.LayMines] = 21
        gSmallIconIndex[kTechId.DualMinigunExosuit] = 26
    
    end
    
    local index = gSmallIconIndex[itemTechId]
    if not index then
        index = 0
    end
    
    local y1 = index * smallIconHeight
    local y2 = (index + 1) * smallIconHeight
    
    return 0, y1, smallIconWidth, y2

end

HiddenGUIMarineEquipmentMenu.kBigIconSize = GUIScale( Vector(320, 256, 0) )
HiddenGUIMarineEquipmentMenu.kBigIconOffset = GUIScale(20)

local gBigIconIndex = nil
local bigIconWidth = 400
local bigIconHeight = 300
local function GetBigIconPixelCoords(techId, researched)

    if not gBigIconIndex then
    
        gBigIconIndex = {}
        gBigIconIndex[kTechId.Axe] = 0
        gBigIconIndex[kTechId.Pistol] = 1
        gBigIconIndex[kTechId.Rifle] = 2
        gBigIconIndex[kTechId.Shotgun] = 3
        gBigIconIndex[kTechId.GrenadeLauncher] = 4
        gBigIconIndex[kTechId.Flamethrower] = 5
        gBigIconIndex[kTechId.Jetpack] = 6
        gBigIconIndex[kTechId.Exosuit] = 7
        gBigIconIndex[kTechId.Welder] = 8
        gBigIconIndex[kTechId.LayMines] = 9
        gBigIconIndex[kTechId.DualMinigunExosuit] = 10
    
    end
    
    local index = gBigIconIndex[techId]
    if not index then
        index = 0
    end
    
    local x1 = 0
    local x2 = bigIconWidth
    
    if not researched then
    
        x1 = bigIconWidth
        x2 = bigIconWidth * 2
        
    end
    
    local y1 = index * bigIconHeight
    local y2 = (index + 1) * bigIconHeight
    
    return x1, y1, x2, y2

end

HiddenGUIMarineEquipmentMenu.kTextColor = Color(kMarineFontColor)

HiddenGUIMarineEquipmentMenu.kMenuWidth = GUIScale(190)
HiddenGUIMarineEquipmentMenu.kMenuHeight = GUIScale(64)

HiddenGUIMarineEquipmentMenu.kPadding = GUIScale(8)
HiddenGUIMarineEquipmentMenu.kBackgroundWidth = GUIScale(600)
HiddenGUIMarineEquipmentMenu.kBackgroundHeight = GUIScale(520)
// We want the background graphic to look centered around the circle even though there is the part coming off to the right.
HiddenGUIMarineEquipmentMenu.kBackgroundXOffset = GUIScale(0)

HiddenGUIMarineEquipmentMenu.kEnabledColor = Color(1, 1, 1, 1)
HiddenGUIMarineEquipmentMenu.kCloseButtonColor = Color(1, 1, 0, 1)

HiddenGUIMarineEquipmentMenu.kButtonWidth = GUIScale(160)
HiddenGUIMarineEquipmentMenu.kButtonHeight = GUIScale(64)

HiddenGUIMarineEquipmentMenu.kItemNameOffsetX = GUIScale(28)
HiddenGUIMarineEquipmentMenu.kItemNameOffsetY = GUIScale(256)

HiddenGUIMarineEquipmentMenu.kItemDescriptionOffsetY = GUIScale(300)
HiddenGUIMarineEquipmentMenu.kItemDescriptionSize = GUIScale( Vector(450, 180, 0) )

HiddenGUIMarineEquipmentMenu.weaponList = {   
	        kTechId.Rifle,
	        kTechId.Shotgun,
	        kTechId.GrenadeLauncher,
	        kTechId.Flamethrower,
	    }
	    
HiddenGUIMarineEquipmentMenu.equipmentList = {   
	        kTechId.Welder,
	        kTechId.LayMines,
	        kTechId.Jetpack,
	    }	    

function HiddenGUIMarineEquipmentMenu:Initialize()

    GUIAnimatedScript.Initialize(self)

    self.mouseOverStates = { }
    
    local player = Client.GetLocalPlayer()
    
    self.selectedWeapon = Client:GetSelectedWeapon() or kTechId.Rifle
    self.selectedEquipment = Client:GetSelectedEquipment() or kTechId.Welder
    
    self:_InitializeBackground()
    self:_InitializeMenuHeader()
    self:_InitializeWeapons()
    self:_InitializeEquipment()
    self:_InitializeSaveButton() 
    self:_InitializeCloseButton()    
    self:_InitializeContent()    
end

function HiddenGUIMarineEquipmentMenu:Update(deltaTime)
    GUIAnimatedScript.Update(self, deltaTime)

    self:_UpdateItems(deltaTime)
    self:_UpdateSaveButton(deltaTime)
    self:_UpdateCloseButton(deltaTime)   
    self:_UpdateContent(deltaTime)     
end

function HiddenGUIMarineEquipmentMenu:Uninitialize()
    GUIAnimatedScript.Uninitialize(self)

    self:_UninitializeBackground()
    self:_UninitializeItems()
    self:_UninitializeSaveButton()
    self:_UninitializeCloseButton()
    self:_UninitializeContent()
end

function HiddenGUIMarineEquipmentMenu:_InitializeBackground()
    // This invisible background is used for centering only.
    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(Color(0.05, 0.05, 0.1, 0.5)) // alpha was 0.7
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)
    
    //self.repeatingBGTexture = GUIManager:CreateGraphicItem()
    //self.repeatingBGTexture:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    //self.repeatingBGTexture:SetTexture(HiddenGUIMarineEquipmentMenu.kRepeatingBackground)
    //self.repeatingBGTexture:SetTexturePixelCoordinates(0, 0, Client.GetScreenWidth(), Client.GetScreenHeight())
    //self.background:AddChild(self.repeatingBGTexture)
        
    self.content = GUIManager:CreateGraphicItem()
    // HiddenGUIMarineEquipmentMenu.kMenuWidth * 2 + HiddenGUIMarineEquipmentMenu.kArrowWidth * 2 + HiddenGUIMarineEquipmentMenu.kPadding * 2
    local size = Vector(HiddenGUIMarineEquipmentMenu.kBackgroundWidth, HiddenGUIMarineEquipmentMenu.kBackgroundHeight, 0)
    self.content:SetSize(size)
    self.content:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.content:SetPosition(Vector(0, -size.y / 2, 0))
    self.content:SetTexture(HiddenGUIMarineEquipmentMenu.kContentBgTexture)
    self.content:SetTexturePixelCoordinates(0, 0, HiddenGUIMarineEquipmentMenu.kBackgroundWidth, HiddenGUIMarineEquipmentMenu.kBackgroundHeight)
    self.content:SetColor( Color(1,1,1,0.8) )
    self.background:AddChild(self.content)
                
    self.scanLine = self:CreateAnimatedGraphicItem()
    self.scanLine:SetSize( Vector( Client.GetScreenWidth(), HiddenGUIMarineEquipmentMenu.kScanLineHeight, 0) )
    self.scanLine:SetTexture(HiddenGUIMarineEquipmentMenu.kScanLineTexture)
    self.scanLine:SetLayer(kGUILayerPlayerHUDForeground4)
    self.scanLine:SetIsScaling(false)
    
    self.scanLine:SetPosition( Vector(0, -HiddenGUIMarineEquipmentMenu.kScanLineHeight, 0) )
    self.scanLine:SetPosition( Vector(0, Client.GetScreenHeight() + HiddenGUIMarineEquipmentMenu.kScanLineHeight, 0), HiddenGUIMarineEquipmentMenu.kScanLineAnimDuration, "MARINEBUY_SCANLINE", AnimateLinear, MoveDownAnim)
end

function HiddenGUIMarineEquipmentMenu:_UninitializeBackground()    
    GUI.DestroyItem(self.background)
    self.background = nil
    
    self.content = nil
end

function HiddenGUIMarineEquipmentMenu:_InitializeMenuHeader()
    self.menuHeader = GetGUIManager():CreateGraphicItem()
    
    local size = self.content:GetSize()
    self.menuHeader:SetSize(Vector(size.x, HiddenGUIMarineEquipmentMenu.kMenuHeight, 0))
    self.menuHeader:SetPosition(Vector(0, -HiddenGUIMarineEquipmentMenu.kMenuHeight, 0))
    self.menuHeader:SetTexture(HiddenGUIMarineEquipmentMenu.kContentBgBackTexture)
    self.menuHeader:SetTexturePixelCoordinates(0, 0, HiddenGUIMarineEquipmentMenu.kMenuWidth, HiddenGUIMarineEquipmentMenu.kMenuHeight)
    self.content:AddChild(self.menuHeader) 
    
    self.menuHeaderTitle = GetGUIManager():CreateTextItem()
    self.menuHeaderTitle:SetFontName(HiddenGUIMarineEquipmentMenu.kFont)
    self.menuHeaderTitle:SetFontIsBold(true)
    self.menuHeaderTitle:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.menuHeaderTitle:SetTextAlignmentX(GUIItem.Align_Center)
    self.menuHeaderTitle:SetTextAlignmentY(GUIItem.Align_Center)
    self.menuHeaderTitle:SetColor(HiddenGUIMarineEquipmentMenu.kTextColor)
    self.menuHeaderTitle:SetText(Locale.ResolveString("HIDDEN_MARINE_SELECT_EQUIPMENT"))
    self.menuHeader:AddChild(self.menuHeaderTitle)    
end

function HiddenGUIMarineEquipmentMenu:_InitializeWeapons()    
    self.menu = GetGUIManager():CreateGraphicItem()
    self.menu:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kMenuWidth * 2 - HiddenGUIMarineEquipmentMenu.kArrowWidth * 2 - HiddenGUIMarineEquipmentMenu.kPadding * 2, 0, 0))
    self.menu:SetTexture(HiddenGUIMarineEquipmentMenu.kContentBgTexture)
    self.menu:SetSize(Vector(HiddenGUIMarineEquipmentMenu.kMenuWidth, HiddenGUIMarineEquipmentMenu.kBackgroundHeight, 0))
    self.menu:SetTexturePixelCoordinates(0, 0, HiddenGUIMarineEquipmentMenu.kMenuWidth, HiddenGUIMarineEquipmentMenu.kBackgroundHeight)
    self.content:AddChild(self.menu)
    
    self.itemButtons = { }
    
    local selectorPosX = -HiddenGUIMarineEquipmentMenu.kSelectorSize.x + HiddenGUIMarineEquipmentMenu.kPadding
    local fontScaleVector = Vector(0.8, 0.8, 0)
    
    for k, itemTechId in ipairs(self.weaponList) do    
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(HiddenGUIMarineEquipmentMenu.kMenuIconSize)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
        graphicItem:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kMenuIconSize.x/ 2, HiddenGUIMarineEquipmentMenu.kIconTopOffset + (HiddenGUIMarineEquipmentMenu.kMenuIconSize.y) * k - HiddenGUIMarineEquipmentMenu.kMenuIconSize.y, 0))
        graphicItem:SetTexture(kInventoryIconsTexture)
        graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(itemTechId))
        
        local graphicItemActive = GUIManager:CreateGraphicItem()
        graphicItemActive:SetSize(HiddenGUIMarineEquipmentMenu.kSelectorSize)
        
        graphicItemActive:SetPosition(Vector(selectorPosX, -HiddenGUIMarineEquipmentMenu.kSelectorSize.y / 2, 0))
        graphicItemActive:SetAnchor(GUIItem.Right, GUIItem.Center)
        graphicItemActive:SetTexture(HiddenGUIMarineEquipmentMenu.kMenuSelectionTexture)
        graphicItemActive:SetIsVisible(false)
        
        graphicItem:AddChild(graphicItemActive)
                       
        local selectedArrow = GUIManager:CreateGraphicItem()
        selectedArrow:SetSize(Vector(HiddenGUIMarineEquipmentMenu.kArrowWidth, HiddenGUIMarineEquipmentMenu.kArrowHeight, 0))
        selectedArrow:SetAnchor(GUIItem.Left, GUIItem.Center)
        selectedArrow:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kArrowWidth - HiddenGUIMarineEquipmentMenu.kPadding, -HiddenGUIMarineEquipmentMenu.kArrowHeight * 0.5, 0))
        selectedArrow:SetTexture(HiddenGUIMarineEquipmentMenu.kArrowTexture)
        selectedArrow:SetColor(HiddenGUIMarineEquipmentMenu.kTextColor)
        selectedArrow:SetTextureCoordinates(unpack(HiddenGUIMarineEquipmentMenu.kArrowTexCoords))
        selectedArrow:SetIsVisible(false)
        
        graphicItem:AddChild(selectedArrow) 
                
        self.menu:AddChild(graphicItem)
        table.insert(self.itemButtons, { Button = graphicItem, Highlight = graphicItemActive, TechId = itemTechId, Arrow = selectedArrow, IsWeapon = true } )
    
    end
    
    // to prevent wrong display before the first update
    self:_UpdateItems(0)
end

function HiddenGUIMarineEquipmentMenu:_UpdateItems(deltaTime)
    for i, item in ipairs(self.itemButtons) do    
        if self:_GetIsMouseOver(item.Button) then        
            item.Highlight:SetIsVisible(true)
            self.hoverItem = item.TechId
        else 
            item.Highlight:SetIsVisible(false)
        end

        local useColor = Color(1,1,1,1)

        item.Button:SetColor(useColor)
        item.Highlight:SetColor(useColor)
        item.Arrow:SetIsVisible(self.selectedWeapon == item.TechId or self.selectedEquipment == item.TechId)        
    end
end

function HiddenGUIMarineEquipmentMenu:_UninitializeItems()
    for i, item in ipairs(self.itemButtons) do
        GUI.DestroyItem(item.Button)
    end
    self.itemButtons = nil
end

function HiddenGUIMarineEquipmentMenu:_InitializeEquipment()    
    self.equipmentMenu = GetGUIManager():CreateGraphicItem()
    self.equipmentMenu:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kMenuWidth - HiddenGUIMarineEquipmentMenu.kPadding * 2, 0, 0))
    self.equipmentMenu:SetTexture(HiddenGUIMarineEquipmentMenu.kContentBgTexture)
    self.equipmentMenu:SetSize(Vector(HiddenGUIMarineEquipmentMenu.kMenuWidth, HiddenGUIMarineEquipmentMenu.kBackgroundHeight, 0))
    self.equipmentMenu:SetTexturePixelCoordinates(0, 0, HiddenGUIMarineEquipmentMenu.kMenuWidth, HiddenGUIMarineEquipmentMenu.kBackgroundHeight)
    self.content:AddChild(self.equipmentMenu)
            
    local selectorPosX = -HiddenGUIMarineEquipmentMenu.kSelectorSize.x + HiddenGUIMarineEquipmentMenu.kPadding
    local fontScaleVector = Vector(0.8, 0.8, 0)
    
    for k, itemTechId in ipairs(self.equipmentList) do    
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(HiddenGUIMarineEquipmentMenu.kMenuIconSize)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
        graphicItem:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kMenuIconSize.x/ 2, HiddenGUIMarineEquipmentMenu.kIconTopOffset + (HiddenGUIMarineEquipmentMenu.kMenuIconSize.y) * k - HiddenGUIMarineEquipmentMenu.kMenuIconSize.y, 0))
        graphicItem:SetTexture(kInventoryIconsTexture)
        graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(itemTechId))
        
        local graphicItemActive = GUIManager:CreateGraphicItem()
        graphicItemActive:SetSize(HiddenGUIMarineEquipmentMenu.kSelectorSize)
        
        graphicItemActive:SetPosition(Vector(selectorPosX, -HiddenGUIMarineEquipmentMenu.kSelectorSize.y / 2, 0))
        graphicItemActive:SetAnchor(GUIItem.Right, GUIItem.Center)
        graphicItemActive:SetTexture(HiddenGUIMarineEquipmentMenu.kMenuSelectionTexture)
        graphicItemActive:SetIsVisible(false)
        
        graphicItem:AddChild(graphicItemActive)
                       
        local selectedArrow = GUIManager:CreateGraphicItem()
        selectedArrow:SetSize(Vector(HiddenGUIMarineEquipmentMenu.kArrowWidth, HiddenGUIMarineEquipmentMenu.kArrowHeight, 0))
        selectedArrow:SetAnchor(GUIItem.Left, GUIItem.Center)
        selectedArrow:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kArrowWidth - HiddenGUIMarineEquipmentMenu.kPadding, -HiddenGUIMarineEquipmentMenu.kArrowHeight * 0.5, 0))
        selectedArrow:SetTexture(HiddenGUIMarineEquipmentMenu.kArrowTexture)
        selectedArrow:SetColor(HiddenGUIMarineEquipmentMenu.kTextColor)
        selectedArrow:SetTextureCoordinates(unpack(HiddenGUIMarineEquipmentMenu.kArrowTexCoords))
        selectedArrow:SetIsVisible(false)
        
        graphicItem:AddChild(selectedArrow) 
                
        self.equipmentMenu:AddChild(graphicItem)
        table.insert(self.itemButtons, { Button = graphicItem, Highlight = graphicItemActive, TechId = itemTechId, Arrow = selectedArrow, IsWeapon = false } )
    
    end
    
    // to prevent wrong display before the first update
    self:_UpdateItems(0)
end

function HiddenGUIMarineEquipmentMenu:_InitializeCloseButton()
    self.closeButton = GUIManager:CreateGraphicItem()
    self.closeButton:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.closeButton:SetSize(Vector(HiddenGUIMarineEquipmentMenu.kButtonWidth, HiddenGUIMarineEquipmentMenu.kButtonHeight, 0))
    self.closeButton:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kButtonWidth, HiddenGUIMarineEquipmentMenu.kPadding, 0))
    self.closeButton:SetTexture(HiddenGUIMarineEquipmentMenu.kButtonTexture)
    self.closeButton:SetLayer(kGUILayerPlayerHUDForeground4)
    self.content:AddChild(self.closeButton)
    
    self.closeButtonText = GUIManager:CreateTextItem()
    self.closeButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.closeButtonText:SetFontName(HiddenGUIMarineEquipmentMenu.kFont)
    self.closeButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.closeButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.closeButtonText:SetText(Locale.ResolveString("EXIT"))
    self.closeButtonText:SetFontIsBold(true)
    self.closeButtonText:SetColor(HiddenGUIMarineEquipmentMenu.kCloseButtonColor)
    self.closeButton:AddChild(self.closeButtonText)    
end

function HiddenGUIMarineEquipmentMenu:_UpdateCloseButton(deltaTime)
    if self:_GetIsMouseOver(self.closeButton) then
        self.closeButton:SetColor(Color(1, 1, 1, 1))
    else
        self.closeButton:SetColor(Color(0.5, 0.5, 0.5, 1))
    end
end

function HiddenGUIMarineEquipmentMenu:_UninitializeCloseButton()    
    GUI.DestroyItem(self.closeButton)
    self.closeButton = nil
end

function HiddenGUIMarineEquipmentMenu:_InitializeSaveButton()
    self.saveButton = GUIManager:CreateGraphicItem()
    self.saveButton:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.saveButton:SetSize(Vector(HiddenGUIMarineEquipmentMenu.kButtonWidth, HiddenGUIMarineEquipmentMenu.kButtonHeight, 0))
    self.saveButton:SetPosition(Vector(-(HiddenGUIMarineEquipmentMenu.kButtonWidth * 2) - HiddenGUIMarineEquipmentMenu.kPadding, HiddenGUIMarineEquipmentMenu.kPadding, 0))
    self.saveButton:SetTexture(HiddenGUIMarineEquipmentMenu.kButtonTexture)
    self.saveButton:SetLayer(kGUILayerPlayerHUDForeground4)
    self.content:AddChild(self.saveButton)
    
    self.saveButtonText = GUIManager:CreateTextItem()
    self.saveButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.saveButtonText:SetFontName(HiddenGUIMarineEquipmentMenu.kFont)
    self.saveButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.saveButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.saveButtonText:SetText(Locale.ResolveString("HIDDEN_MARINE_SELECT_EQUIPMENT_SAVE"))
    self.saveButtonText:SetFontIsBold(true)
    self.saveButtonText:SetColor(HiddenGUIMarineEquipmentMenu.kCloseButtonColor)
    self.saveButton:AddChild(self.saveButtonText)    
end

function HiddenGUIMarineEquipmentMenu:_UpdateSaveButton(deltaTime)
    if self:_GetIsMouseOver(self.saveButton) then
        self.saveButton:SetColor(Color(1, 1, 1, 1))
    else
        self.saveButton:SetColor(Color(0.5, 0.5, 0.5, 1))
    end
end

function HiddenGUIMarineEquipmentMenu:_UninitializeSaveButton()    
    GUI.DestroyItem(self.saveButton)
    self.saveButton = nil
end

function HiddenGUIMarineEquipmentMenu:_InitializeContent()
    self.itemName = GUIManager:CreateTextItem()
    self.itemName:SetFontName(HiddenGUIMarineEquipmentMenu.kFont)
    self.itemName:SetFontIsBold(true)
    self.itemName:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.itemName:SetPosition(Vector(HiddenGUIMarineEquipmentMenu.kItemNameOffsetX , HiddenGUIMarineEquipmentMenu.kItemNameOffsetY , 0))
    self.itemName:SetTextAlignmentX(GUIItem.Align_Min)
    self.itemName:SetTextAlignmentY(GUIItem.Align_Min)
    self.itemName:SetColor(HiddenGUIMarineEquipmentMenu.kTextColor)
    self.itemName:SetText("no selection")
    
    self.content:AddChild(self.itemName)
    
    self.portrait = GetGUIManager():CreateGraphicItem()
    self.portrait:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.portrait:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kBigIconSize.x/2, HiddenGUIMarineEquipmentMenu.kBigIconOffset, 0))
    self.portrait:SetSize(HiddenGUIMarineEquipmentMenu.kBigIconSize)
    self.portrait:SetTexture(HiddenGUIMarineEquipmentMenu.kBigIconTexture)
    self.portrait:SetTexturePixelCoordinates(GetBigIconPixelCoords(kTechId.Axe))
    self.portrait:SetIsVisible(false)
    self.content:AddChild(self.portrait)
    
    self.itemDescription = GetGUIManager():CreateTextItem()
    self.itemDescription:SetFontName(HiddenGUIMarineEquipmentMenu.kDescriptionFontName)
    //self.itemDescription:SetFontIsBold(true)
    self.itemDescription:SetFontSize(HiddenGUIMarineEquipmentMenu.kDescriptionFontSize)
    self.itemDescription:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.itemDescription:SetPosition(Vector(-HiddenGUIMarineEquipmentMenu.kItemDescriptionSize.x / 2, HiddenGUIMarineEquipmentMenu.kItemDescriptionOffsetY, 0))
    self.itemDescription:SetTextAlignmentX(GUIItem.Align_Min)
    self.itemDescription:SetTextAlignmentY(GUIItem.Align_Min)
    self.itemDescription:SetColor(HiddenGUIMarineEquipmentMenu.kTextColor)
    self.itemDescription:SetTextClipped(true, HiddenGUIMarineEquipmentMenu.kItemDescriptionSize.x - 2* HiddenGUIMarineEquipmentMenu.kPadding, HiddenGUIMarineEquipmentMenu.kItemDescriptionSize.y - HiddenGUIMarineEquipmentMenu.kPadding)
    
    self.content:AddChild(self.itemDescription)    
end

function HiddenGUIMarineEquipmentMenu:_UpdateContent(deltaTime)
    local techId = self.hoverItem
    if not self.hoverItem then
        techId = self.selectedWeapon
    end
    
    if techId then   
        local color = Color(1, 1, 1, 1)
    
        self.itemName:SetColor(color)
        self.portrait:SetColor(color)        
        self.itemDescription:SetColor(color)
        
        self.itemName:SetText(Locale.ResolveString(LookupTechData(techId, kTechDataDisplayName, "")))
        self.portrait:SetTexturePixelCoordinates(GetBigIconPixelCoords(techId, researched))
        self.itemDescription:SetText(MarineBuy_GetWeaponDescription(techId))
        self.itemDescription:SetTextClipped(true, HiddenGUIMarineEquipmentMenu.kItemDescriptionSize.x - 2* HiddenGUIMarineEquipmentMenu.kPadding, HiddenGUIMarineEquipmentMenu.kItemDescriptionSize.y - HiddenGUIMarineEquipmentMenu.kPadding)
    end
    
    local contentVisible = techId ~= nil and techId ~= kTechId.None
    
    self.portrait:SetIsVisible(contentVisible)
    self.itemName:SetIsVisible(contentVisible)
    self.itemDescription:SetIsVisible(contentVisible)    
end

function HiddenGUIMarineEquipmentMenu:_UninitializeContent()
    GUI.DestroyItem(self.itemName)
end

function HiddenGUIMarineEquipmentMenu:_GetIsMouseOver(overItem)
    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        MarineBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver    
end

function HiddenGUIMarineEquipmentMenu:SendKeyEvent(key, down)
    local closeMenu = false
    local inputHandled = false
    
    if key == InputKey.MouseButton0 and self.mousePressed ~= down then
        self.mousePressed = down
        
        local mouseX, mouseY = Client.GetCursorPosScreen()
        if down then                    
            inputHandled, closeMenu = self:_HandleItemClicked(mouseX, mouseY) or inputHandled
            
            if not inputHandled then            
                // Check if the close button was pressed.
                if self:_GetIsMouseOver(self.closeButton) then
                    closeMenu = true
                    inputHandled = true
                elseif self:_GetIsMouseOver(self.saveButton) then
                    closeMenu = true
                    inputHandled = true    
                    
                    local player = Client.GetLocalPlayer()
                    if (self.selectedWeapon ~= Client:GetSelectedWeapon() and self.selectedEquipment ~= Client:GetSelectedEquipment()) then
                        Client:SetSelectedEquipment(self.selectedWeapon, self.selectedEquipment)
                    end    
                end
            end
        end        
    end
    
    if (closeMenu) then
        local player = Client.GetLocalPlayer()
        if player then
            player:CloseMenu()
        end
    end
    
    return inputHandled
end    

function HiddenGUIMarineEquipmentMenu:_HandleItemClicked(mouseX, mouseY)
    for i, item in ipairs(self.itemButtons) do    
        if self:_GetIsMouseOver(item.Button) then
            if (item.IsWeapon) then
                self.selectedWeapon = item.TechId
            else
                self.selectedEquipment = item.TechId
            end    
            
            return true, true           
        end         
    end
    
    return false, false    
end