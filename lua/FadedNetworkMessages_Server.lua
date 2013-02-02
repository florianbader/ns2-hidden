// ===================== Faded Mod =====================
//
// lua\FadedNetworkMessages_Server.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

Script.Load("lua/TechData.lua")

local floor = math.floor

local function OnMessageSelectEquipment(client, message)
    local gameTime = GetGamerules():GetGameStartTime()
    if gameTime ~= 0 then
        gameTime = floor(Shared.GetTime()) - gameTime
    end
    
    if (gameTime >= kFadedModTimeInSecondsSelectingEquipmentIsAllowed) then
        return
    end    

    local player = client:GetControllingPlayer()
        
    local equipment = message.Equipment or kTechId.Welder
    local equipmentMapName = LookupTechData(equipment, kTechDataMapName)
    
    // Remove all weapons and equipment and give the marine back his pistol and axe.
    player:DropAllWeapons()
    player:DestroyWeapons()
    player = player:RemoveJetpack()
    
    player:GiveItem(Axe.kMapName)
    player:GiveItem(Pistol.kMapName)
    player:GiveItem(Rifle.kMapName)
        
    // Give the marine the selected weapon and equipment.
    if equipment == kTechId.Jetpack then
        player:GiveJetpack()
    else
        if player:GiveItem(equipmentMapName) then                
            Shared.PlayWorldSound(nil, Marine.kGunPickupSound, nil, player:GetOrigin())    
        end    
    end 
    
    // If the player gets a jetpack, we need to get the new player entitiy 
    player = client:GetControllingPlayer()
    
    local weapon = message.Weapon or kTechId.Rifle
    local weaponMapName = LookupTechData(weapon, kTechDataMapName)
    
    if player:GiveItem(weaponMapName) then                
        Shared.PlayWorldSound(nil, Marine.kGunPickupSound, nil, player:GetOrigin())    
    end      
end

function Marine:RemoveJetpack()
    if (not self:isa("JetpackMarine")) then return self end

    local activeWeapon = self:GetActiveWeapon()
    local activeWeaponMapName = nil
    local health = self:GetHealth()
    
    if activeWeapon ~= nil then
        activeWeaponMapName = activeWeapon:GetMapName()
    end
    
    local marine = self:Replace(Marine.kMapName, self:GetTeamNumber(), true, Vector(self:GetOrigin()))
    
    marine:SetActiveWeapon(activeWeaponMapName)
    marine:SetHealth(health)
    return marine
end    

Server.HookNetworkMessage("SelectEquipment", OnMessageSelectEquipment)