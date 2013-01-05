// ===================== Hidden Mod =====================
//
// lua\HiddenServer.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

// Load the ns2 server script
Script.Load("lua/Server.lua")

// Load libraries
Script.Load("lua/libs/LibLoader/LibLoader.lua")
Script.Load("lua/libs/LibLocales-1.0/LibLocales.lua")
Script.Load("lua/libs/LibMessages-1.0/LibMessages.lua")

// Load hidden mod server scripts
Script.Load("lua/HiddenGlobals.lua")
Script.Load("lua/HiddenShared.lua")
Script.Load("lua/HiddenUpgradableMixin.lua")
Script.Load("lua/HiddenTeam.lua")
Script.Load("lua/HiddenAlien.lua")
Script.Load("lua/HiddenCloak.lua")
Script.Load("lua/HiddenRoundTimer.lua")
Script.Load("lua/HiddenSounds.lua")
Script.Load("lua/HiddenConsoleCommands.lua")
Script.Load("lua/HiddenWallGrip.lua")
Script.Load("lua/HiddenNetworkMessages_Server.lua")
Script.Load("lua/HiddenWeapon.lua")
Script.Load("lua/HiddenParasite.lua")
Script.Load("lua/HiddenFade.lua")
Script.Load("lua/HiddenGamerules.lua")

// Only include the Test script in the development version
if (kHiddenModVersion:lower():find("development")) then
    Shared:HiddenMessage("Warning! This is a development version! It's for testing purpose only!")
    Script.Load("lua/HiddenTest.lua")
elseif (kHiddenModVersion:lower():find("alpha")) then
    Shared:HiddenMessage("Warning! This is an alpha version, which means it's not finished yet!")
end    