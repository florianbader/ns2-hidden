// ===================== Faded Mod =====================
//
// lua\FadedClient.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

// Load the ns2 client script
Script.Load("lua/Client.lua")

// Load faded mod client scripts
Script.Load("lua/FadedShared.lua")
Script.Load("lua/FadedHUD.lua")
Script.Load("lua/FadedHelpMixin.lua")
Script.Load("lua/FadedAmbientSound.lua")

GetGUIManager():CreateGUIScript("FadedGUIFeedback")

// Only include the Test script in the development version
if (kFadedModVersion:lower():find("development")) then
    Script.Load("lua/FadedTest.lua")
end