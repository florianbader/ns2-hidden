// ===================== Faded Mod =====================
//
// lua\FadedRoundTimer.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local strformat = string.format
local floor = math.floor

class 'FadedRoundTimer'

function FadedRoundTimer:GetGameStartTime()
    local entityList = Shared.GetEntitiesWithClassname("GameInfo")
    if (entityList:GetSize() > 0) then    
        local gameInfo = entityList:GetEntityAtIndex(0)
        local state = gameInfo:GetState()
        
        if (state == kGameState.Started) then
            return gameInfo:GetStartTime()
        else 
            return -1    
        end        
    end
    
    return 0    
end

function FadedRoundTimer:GetRoundTime()
    return math.floor(Shared.GetTime() - self:GetGameStartTime())
end

function FadedRoundTimer:GetRoundTimeLeft()
    return floor(kFadedModRoundTimerInSecs - FadedRoundTimer:GetRoundTime())
end

function FadedRoundTimer:GetIsRoundTimeOver()
    if (self:GetGameStartTime() < 0) then return false end
    return (Shared.GetTime() - self:GetGameStartTime() >= kFadedModRoundTimerInSecs)
end   

if (Server) then
    local locale = LibCache:GetLibrary("LibLocales-1.0")

    FadedRoundTimer.AnnounceTimeAt = { 300, 240, 180, 120, 60, 30, 15, 5, 4, 3, 2, 1 }
    FadedRoundTimer.AnnouncedTimeAlready = {}
    
    function FadedRoundTimer:UpdateRoundTimer()
        for _, time in pairs(FadedRoundTimer.AnnounceTimeAt) do
            if (not FadedRoundTimer.AnnouncedTimeAlready[time] and floor(kFadedModRoundTimerInSecs - FadedRoundTimer:GetRoundTime()) == time) then
                Shared:FadedMessage(strformat(locale:ResolveString("HIDDEN_GAME_ENDS_IN"), time))
                FadedRoundTimer.AnnouncedTimeAlready[time] = true
            end    
        end
        
        if (not FadedRoundTimer.AnnouncedTimeAlready["over"] and FadedRoundTimer:GetIsRoundTimeOver()) then        
            Shared:FadedMessage(locale:ResolveString("HIDDEN_GAME_ENDS"))
            FadedRoundTimer.AnnouncedTimeAlready["over"] = true
        end  
    end

    function FadedRoundTimer:Reset()
        FadedRoundTimer.AnnouncedTimeAlready = {}
    end
    
elseif (Client) then
    local playerOnCountDownEnd = Player.OnCountDownEnd
    function Player:OnCountDownEnd()
        playerOnCountDownEnd(self)
        self.fadedRoundTimer = GetGUIManager():CreateGUIScript("FadedGUIRoundTimer")    
    end
    
    local playerOnDestroy = Player.OnDestroy
    function Player:OnDestroy()
        playerOnDestroy(self)
        GetGUIManager():DestroyGUIScriptSingle("FadedGUIRoundTimer")
    end
end