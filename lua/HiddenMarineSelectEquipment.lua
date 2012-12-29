// ===================== Hidden Mod =====================
//
// lua\HiddenMarineSelectEquipment.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

function Marine:Buy()    
    // Don't allow display in the ready room
    if (self:GetTeamNumber() ~= 0 and Client.GetLocalPlayer() == self) then    
        if (not self.hiddenEquipmentMenu) then        
            self.hiddenEquipmentMenu = GetGUIManager():CreateGUIScript("HiddenGUIMarineEquipmentMenu")        
            MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
        else
            self:CloseMenu()
        end           
    end    
end

function Marine:CloseMenu()
    if (self.hiddenEquipmentMenu) then
        GetGUIManager():DestroyGUIScript(self.hiddenEquipmentMenu)
        self.hiddenEquipmentMenu = nil
        MouseTracker_SetIsVisible(false)
        
        return true
    end
    
    return false
end

class 'HiddenEquipment'

function Client:GetSelectedWeapon() 
    self.selectedWeapon = self.selectedWeapon or kTechId.Rifle
    return self.selectedWeapon
end

function Client:GetSelectedEquipment()
    self.selectedEquipment = self.selectedEquipment or kTechId.Welder
    return self.selectedEquipment
end

function Client:SetSelectedWeapon(weapon) 
    self.selectedWeapon = weapon
end

function Client:SetSelectedEquipment(equipment)
    self.selectedEquipment = equipment
end

local marineOnCountDown = Marine.OnCountDown
function Marine:OnCountDown()
    marineOnCountDown(self)
    Client:SendSelectEquipmentMessage()    
end

function Client:SendSelectEquipmentMessage()
    Client.SendNetworkMessage("SelectEquipment", { Weapon = self.selectedWeapon, Equipment = self.selectedEquipment }, true)
end