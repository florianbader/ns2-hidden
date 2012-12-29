// ===================== Hidden Mod =====================
//
// lua\HiddenNetworkMessages_Server.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

Script.Load("lua/TechData.lua")

local function OnMessageSelectEquipment(client, message)
    local player = client:GetControllingPlayer()
        
    local equipment = message.Equipment or kTechId.Welder
    local equipmentMapName = LookupTechData(equipment, kTechDataMapName)
    
    if equipment == kTechId.Jetpack then
        player:GiveJetpack()
    else
        if player:GiveItem(equipmentMapName) then                
            Shared.PlayWorldSound(nil, Marine.kGunPickupSound, nil, player:GetOrigin())    
        end    
    end 
    
    local weapon = message.Weapon or kTechId.Rifle
    local weaponMapName = LookupTechData(weapon, kTechDataMapName)
    
    if player:GiveItem(weaponMapName) then                
        Shared.PlayWorldSound(nil, Marine.kGunPickupSound, nil, player:GetOrigin())    
    end      
end

Server.HookNetworkMessage("SelectEquipment", OnMessageSelectEquipment)