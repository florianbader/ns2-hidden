// ===================== Faded Mod =====================
//
// lua\FadedServerConfig.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

Script.Load("lua/ConfigFileUtility.lua")

local configFileName = "FadedConfig.json"

local defaultConfig = {
    round_time_in_seconds = 300,
    team_attack_spawn_protection = {
        enabled = true,
        duration_in_seconds = 8,
    },
    friendly_fire_enabled = true,
    faded_selection_chance = 0.6,
    time_in_seconds_selecting_equipment_is_allowed = 8,
    all_talk_enabled = true,
}
WriteDefaultConfigFile(configFileName, defaultConfig)

local config = LoadConfigFile(configFileName) or defaultConfig

kFadedModRoundTimerInSecs = config.round_time_in_seconds or defaultConfig.round_time_in_seconds
kFadedModSpawnProtectionEnabled = config.team_attack_spawn_protection.enabled or defaultConfig.team_attack_spawn_protection.enabled
kFadedModSpawnProtectionTime = config.team_attack_spawn_protection.duration_in_seconds or defaultConfig.team_attack_spawn_protection.duration_in_seconds
kFadedModFriendlyFireEnabled = config.friendly_fire_enabled or defaultConfig.faded_selection_chance
kFadedModFadedSelectionChance = config.faded_selection_chance or defaultConfig.faded_selection_chance
kFadedModTimeInSecondsSelectingEquipmentIsAllowed = config.time_in_seconds_selecting_equipment_is_allowed or defaultConfig.time_in_seconds_selecting_equipment_is_allowed
kFadedModAllTalkEnabled = config.all_talk_enabled or defaultConfig.all_talk_enabled