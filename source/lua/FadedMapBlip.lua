// ===================== Faded Mod =====================
//
// lua\FadedMapBlip.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local tinsert = table.insert

local losMixinUpdateLOS = LOSMixin.UpdateLOS
function LOSMixin:UpdateLOS()
    losMixinUpdateLOS(self)
        
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("Marine")) do
        player:SetIsSighted(true, self)
    end 
end 

if (Client) then
    local playerUIGetStaticMapBlips = PlayerUI_GetStaticMapBlips
    function PlayerUI_GetStaticMapBlips()
        local blipsData = playerUIGetStaticMapBlips()
        
        local player = Client.GetLocalPlayer()
                
        if (player:isa("Fade") and player:GetDarkVisionEnabled() == false) then
            local newBlipsData = {}
            local index = 1
                                    
                                    
            for i = 1, #blipsData / 8 do
                local blipTeam = blipsData[index + 6]
                
                if (blipTeam ~= kMinimapBlipTeam.Marine and blipTeam ~= kMinimapBlipTeam.Enemy) then
                    for x = 0, 7 do
                        tinsert(newBlipsData, blipsData[index + x])
                    end    
                end
            
                index = index + 8
            end
            
            return newBlipsData
        end        
        
        return blipsData
    end
end