// ===================== Faded Mod =====================
//
// lua\FadedGUIRoundTimer.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local strformat = string.format

class 'FadedGUIRoundTimer' (GUIScript)

FadedGUIRoundTimer.kGameTimeBackgroundSize = Vector(200, GUIScale(32), 0)
FadedGUIRoundTimer.kFontName = "fonts/AgencyFB_large.fnt"
FadedGUIRoundTimer.kGameTimeTextSize = GUIScale(22)

function FadedGUIRoundTimer:Initialize()
    self.gameTimeBackground = GUIManager:CreateGraphicItem()
    self.gameTimeBackground:SetSize(FadedGUIRoundTimer.kGameTimeBackgroundSize)
    self.gameTimeBackground:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.gameTimeBackground:SetPosition( Vector(- FadedGUIRoundTimer.kGameTimeBackgroundSize.x / 2, 5, 0) )
    self.gameTimeBackground:SetIsVisible(false)
    self.gameTimeBackground:SetColor(Color(0,0,0,0.5))
    self.gameTimeBackground:SetLayer(kGUILayerCountDown)
    
    self.gameTime = GUIManager:CreateTextItem()
    self.gameTime:SetFontName(FadedGUIRoundTimer.kFontName)
    self.gameTime:SetFontSize(FadedGUIRoundTimer.kGameTimeTextSize)
    self.gameTime:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.gameTime:SetTextAlignmentX(GUIItem.Align_Center)
    self.gameTime:SetTextAlignmentY(GUIItem.Align_Center)
    self.gameTime:SetColor(Color(1, 1, 1, 1))
    self.gameTime:SetText("")
    self.gameTimeBackground:AddChild(self.gameTime)
end    

function FadedGUIRoundTimer:Uninitialize()
    GUI.DestroyItem(self.gameTime)
    self.gameTime = nil
    GUI.DestroyItem(self.gameTimeBackground)
    self.gameTimeBackground = nil
end

function FadedGUIRoundTimer:Update(deltaTime)    
    local gameTime = FadedRoundTimer:GetRoundTimeLeft()
    local isVisible = gameTime and gameTime >= 0   
        
    self.gameTimeBackground:SetIsVisible(isVisible)
    self.gameTime:SetIsVisible(isVisible)
    
    local minutes = math.floor(gameTime/60)
    local seconds = gameTime - minutes*60
    local gameTimeText = strformat("%d:%02d", minutes, seconds)    
    self.gameTime:SetText(gameTimeText)
end    