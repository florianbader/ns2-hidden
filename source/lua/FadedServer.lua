// ===================== Faded Mod =====================
//
// lua\FadedServer.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

// Load the ns2 server script
Script.Load("lua/Server.lua")

// Load faded mod server scripts

Script.Load("lua/FadedShared.lua")
Script.Load("lua/FadedServerConfig.lua")
Script.Load("lua/FadedUpgradableMixin.lua")
Script.Load("lua/FadedTeam.lua")
Script.Load("lua/FadedSounds.lua")
Script.Load("lua/FadedConsoleCommands.lua")
Script.Load("lua/FadedNetworkMessages_Server.lua")
Script.Load("lua/FadedWeapon.lua")
Script.Load("lua/FadedTeamAttack.lua")
Script.Load("lua/FadedPlayer_Server.lua")
Script.Load("lua/FadedPointGiverMixin.lua")
Script.Load("lua/FadedAcidRockets.lua")
Script.Load("lua/FadedGamerules.lua")
Script.Load("lua/FadedChatCommands.lua")

// Only include the Test script in the development version
if (kFadedModVersion:lower():find("development")) then
    Shared:FadedMessage("Warning! This is a development version! It's for testing purpose only!")
    Script.Load("lua/FadedTest.lua")
elseif (kFadedModVersion:lower():find("alpha")) then
    Shared:FadedMessage("Warning! This is an alpha version, which means it's not finished yet!")
elseif (kFadedModVersion:lower():find("beta")) then
    Shared:FadedMessage("This mod is in beta. Feel free to leave feedback on the Steam workshop page.")
end    
