// ===================== Hidden Mod =====================
//
// lua\HiddenServerConfig.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

Script.Load("lua/ConfigFileUtility.lua")

local configFileName = "HiddenConfig.json"

local defaultConfig = {
    round_time_in_seconds = 300,
    team_attack_spawn_protection = {
        enabled = true,
        duration_in_seconds = 8,
    },
    friendly_fire_enabled = true,
    hidden_selection_chance = 0.6,
}
WriteDefaultConfigFile(configFileName, defaultConfig)

local config = LoadConfigFile(configFileName) or defaultConfig

kHiddenModRoundTimerInSecs = config.round_time_in_seconds or defaultConfig.round_time_in_seconds
kHiddenModSpawnProtectionEnabled = config.team_attack_spawn_protection.enabled or defaultConfig.team_attack_spawn_protection.enabled
kHiddenModSpawnProtectionTime = config.team_attack_spawn_protection.duration_in_seconds or defaultConfig.team_attack_spawn_protection.duration_in_seconds
kHiddenModFriendlyFireEnabled = config.friendly_fire_enabled or defaultConfig.hidden_selection_chance
kHiddenModHiddenSelectionChance = config.hidden_selection_chance or defaultConfig.hidden_selection_chance