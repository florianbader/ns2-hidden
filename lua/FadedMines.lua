// ===================== Faded Mod =====================
//
// lua\FadedMines.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local layMinesGetPositionForStructure = LayMines.GetPositionForStructure
function LayMines:GetPositionForStructure(player)
    local foundPositionInRange, position, valid = layMinesGetPositionForStructure(self, player)
    
    local nearbyMines = GetEntitiesWithinRange("Mine", player:GetOrigin(), kFadedModMinesRestrictionRange)
    
    // Nearby mines + 1 because we want to lay another mine.
    valid = #nearbyMines + 1 <= kFadedModMinesRestrictionCount
    
    return foundPositionInRange, position, valid        
end