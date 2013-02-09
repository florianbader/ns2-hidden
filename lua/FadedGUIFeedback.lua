// ===================== Faded Mod =====================
//
// lua\FadedGUIFeedback.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

class 'FadedGUIFeedback' (GUIScript)

FadedGUIFeedback.kFontSize = 14
FadedGUIFeedback.kTextFontName = "fonts/AgencyFB_tiny.fnt"
FadedGUIFeedback.kTextColor = Color(1.0, 1.0, 1.0, 0.5)
FadedGUIFeedback.kTextOffset = Vector(55, 8, 0)

function FadedGUIFeedback:Initialize()
    self.buildText = GUIManager:CreateTextItem()
    self.buildText:SetFontSize(FadedGUIFeedback.kFontSize)
    self.buildText:SetFontName(FadedGUIFeedback.kTextFontName)
    self.buildText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.buildText:SetTextAlignmentX(GUIItem.Align_Min)
    self.buildText:SetTextAlignmentY(GUIItem.Align_Center)
    self.buildText:SetPosition(FadedGUIFeedback.kTextOffset)
    self.buildText:SetColor(FadedGUIFeedback.kTextColor)
    self.buildText:SetFontIsBold(true)
    self.buildText:SetText("Faded Mod: " .. kFadedModVersion)    
end

function FadedGUIFeedback:Uninitialize()
    if self.buildText then
        GUI.DestroyItem(self.buildText)
        self.buildText = nil
        self.feedbackText = nil
    end    
end