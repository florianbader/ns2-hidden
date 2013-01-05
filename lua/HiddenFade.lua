// ===================== Hidden Mod =====================
//
// lua\HiddenFade.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

Script.Load("lua/HiddenSwipeLeap.lua")
Script.Load("lua/TechData.lua")

if (Server) then
    Script.Load("lua/HiddenFade_Server.lua")
end

local tinsert = table.insert

if (not kTechData) then
    kTechData = BuildTechData()
end
    
tinsert(kTechData, { [kTechDataId] = kTechId.SwipeLeap, [kTechDataMapName] = SwipeLeap.kMapName, [kTechDataDamageType] = kSwipeDamageType, [kTechDataDisplayName] = "SWIPE_LEAP", [kTechDataTooltipInfo] = "SWIPE_TOOLTIP" })