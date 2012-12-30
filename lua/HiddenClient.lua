// ===================== Hidden Mod =====================
//
// lua\HiddenClient.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

// Load the ns2 client script
Script.Load("lua/Client.lua")

// Load hidden mod client scripts
Script.Load("lua/HiddenGlobals.lua")
Script.Load("lua/HiddenShared.lua")
Script.Load("lua/HiddenCloak.lua")
Script.Load("lua/HiddenWallGrip.lua")
Script.Load("lua/HiddenMarineSelectEquipment.lua")
Script.Load("lua/HiddenRoundTimer.lua")
Script.Load("lua/HiddenParasite.lua")

// Only include the Test script in the development version
if (kHiddenModVersion:lower():find("development")) then
    Script.Load("lua/HiddenTest.lua")
end    