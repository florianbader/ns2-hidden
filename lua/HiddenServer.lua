// ===================== Hidden Mod =====================
//
// lua\HiddenServer.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

// Load the ns2 server script
Script.Load("lua/Server.lua")

// Load hidden mod server scripts
Script.Load("lua/HiddenShared.lua")
Script.Load("lua/HiddenUpgradableMixin.lua")
Script.Load("lua/HiddenTeam.lua")
Script.Load("lua/HiddenAlien.lua")
Script.Load("lua/HiddenCloak.lua")
Script.Load("lua/HiddenRoundTimer.lua")
Script.Load("lua/HiddenSounds.lua")
Script.Load("lua/HiddenConsoleCommands.lua")
Script.Load("lua/HiddenGamerules.lua")

// Only include the Test script in the development version
if (kHiddenModVersion:lower():find("development")) then
    Script.Load("lua/HiddenTest.lua")
end    