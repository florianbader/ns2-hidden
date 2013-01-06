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
Script.Load("lua/HiddenShared.lua")

// Only include the Test script in the development version
if (kHiddenModVersion:lower():find("development")) then
    Script.Load("lua/HiddenTest.lua")
end    