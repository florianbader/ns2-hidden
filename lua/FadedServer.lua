// ===================== Faded Mod =====================
//
// lua\FadedServer.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

// Load libraries
Script.Load("lua/libs/LibCache/LibCache.lua")

// Load the ns2 server script
Script.Load("lua/Server.lua")

// Load libraries
Script.Load("lua/libs/LibLocales-1.0/LibLocales.lua")
Script.Load("lua/libs/LibMessages-1.0/LibMessages.lua")

// Load faded mod server scripts
Script.Load("lua/FadedServerConfig.lua")
Script.Load("lua/FadedShared.lua")
Script.Load("lua/FadedUpgradableMixin.lua")
Script.Load("lua/FadedTeam.lua")
Script.Load("lua/FadedAlien.lua")
Script.Load("lua/FadedSounds.lua")
Script.Load("lua/FadedConsoleCommands.lua")
Script.Load("lua/FadedNetworkMessages_Server.lua")
Script.Load("lua/FadedWeapon.lua")
Script.Load("lua/FadedTeamAttack.lua")
Script.Load("lua/FadedGamerules.lua")

// Only include the Test script in the development version
if (kFadedModVersion:lower():find("development")) then
    Shared:FadedMessage("Warning! This is a development version! It's for testing purpose only!")
    Script.Load("lua/FadedTest.lua")
elseif (kFadedModVersion:lower():find("alpha")) then
    Shared:FadedMessage("Warning! This is an alpha version, which means it's not finished yet!")
end    