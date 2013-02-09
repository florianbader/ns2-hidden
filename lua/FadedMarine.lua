// ===================== Faded Mod =====================
//
// lua\FadedMarine.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

Script.Load("lua/FadedDistortionMixin.lua")

if (Client) then
    Script.Load("lua/FadedMarine_Client.lua")
end

local marineOnCreate = Marine.OnCreate
function Marine:OnCreate()
    marineOnCreate(self)
    
    if (Client) then
        // We don't have any network variables, so this hack should be fine.    
        InitMixin(self, DistortionMixin)
    end
end