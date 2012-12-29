// ===================== Hidden Mod =====================
//
// lua\HiddenWeapon.lua
//
//    Created by: rio (rio@myrio.de)
//
// ======================================================

// We don't want to keep weapons on the floor
local weaponDropped = Weapon.Dropped
function Weapon:Dropped(prevOwner)
    weaponDropped(self, prevOwner)
    DestroyEntity(self)
end