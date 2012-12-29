// ===================== Hidden Mod =====================
//
// lua\HiddenGUIRoundTimer.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

local strformat = string.format

class 'HiddenGUIRoundTimer' (GUIScript)

HiddenGUIRoundTimer.kGameTimeBackgroundSize = Vector(200, GUIScale(32), 0)
HiddenGUIRoundTimer.kFontName = "Calibri"
HiddenGUIRoundTimer.kGameTimeTextSize = GUIScale(22)

function HiddenGUIRoundTimer:Initialize()
    self.gameTimeBackground = GUIManager:CreateGraphicItem()
    self.gameTimeBackground:SetSize(HiddenGUIRoundTimer.kGameTimeBackgroundSize)
    self.gameTimeBackground:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.gameTimeBackground:SetPosition( Vector(- HiddenGUIRoundTimer.kGameTimeBackgroundSize.x / 2, 0, 0) )
    self.gameTimeBackground:SetIsVisible(false)
    self.gameTimeBackground:SetColor(Color(0,0,0,0.5))
    self.gameTimeBackground:SetLayer(kGUILayerCountDown)
    
    self.gameTime = GUIManager:CreateTextItem()
    self.gameTime:SetFontName(HiddenGUIRoundTimer.kFontName)
    self.gameTime:SetFontSize(HiddenGUIRoundTimer.kGameTimeTextSize)
    self.gameTime:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.gameTime:SetTextAlignmentX(GUIItem.Align_Center)
    self.gameTime:SetTextAlignmentY(GUIItem.Align_Center)
    self.gameTime:SetColor(Color(1, 1, 1, 1))
    self.gameTime:SetText("")
    self.gameTimeBackground:AddChild(self.gameTime)
end    

function HiddenGUIRoundTimer:Uninitialize()
    GUI.DestroyItem(self.gameTime)
    self.gameTime = nil
    GUI.DestroyItem(self.gameTimeBackground)
    self.gameTimeBackground = nil
end

function HiddenGUIRoundTimer:Update(deltaTime)    
    local gameTime = HiddenRoundTimer:GetRoundTimeLeft()
    local isVisible = gameTime and gameTime >= 0   
        
    self.gameTimeBackground:SetIsVisible(isVisible)
    self.gameTime:SetIsVisible(isVisible)
    
    local minutes = math.floor(gameTime/60)
    local seconds = gameTime - minutes*60
    local gameTimeText = strformat("%d:%02d", minutes, seconds)    
    self.gameTime:SetText(gameTimeText)
end    