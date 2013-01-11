// ===================== Faded Mod =====================
//
// lua\FadedTeam.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

// Remove the respawn queue
//function Team:PutPlayerInRespawnQueue(player) end
function AlienTeam:PutPlayerInRespawnQueue(player) end
function MarineTeam:PutPlayerInRespawnQueue(player) end

// Remove player respawn ability
function MarineTeam:GetHasAbilityToRespawn() return false end
function AlienTeam:GetHasAbilityToRespawn() return false end

// Don't spawn any initial structures
function AlienTeam:SpawnInitialStructures(techPoint) return nil, nil end
function MarineTeam:SpawnInitialStructures(techPoint) return nil, nil end