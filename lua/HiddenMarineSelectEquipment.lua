// ===================== Hidden Mod =====================
//
// lua\HiddenMarineSelectEquipment.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

local marineHandleButtons = Marine.HandleButtons
function Marine:HandleButtons(input)
    marineHandleButtons(self, input)
    
    //if Client and not Shared.GetIsRunningPrediction() then
    
        self.buyLastFrame = self.buyLastFrame or false
        // Player is bringing up the buy menu (don't toggle it too quickly)
        local buyButtonPressed = bit.band(input.commands, Move.Buy) ~= 0
        if not self.buyLastFrame and buyButtonPressed and Shared.GetTime() > (self.timeLastMenu + 0.3) then        
            self:Buy()
            self.timeLastMenu = Shared.GetTime()            
        end
        
        self.buyLastFrame = buyButtonPressed
        
    //end
end

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

function JetpackMarine:Buy()
    Marine.Buy(self)
end

function JetpackMarine:CloseMenu()
    Marine.CloseMenu(self)
end

if (Client) then
    function Client:GetSelectedWeapon() 
        self.selectedWeapon = self.selectedWeapon or kTechId.Rifle
        return self.selectedWeapon
    end

    function Client:GetSelectedEquipment()
        self.selectedEquipment = self.selectedEquipment or kTechId.Welder
        return self.selectedEquipment
    end

    function Client:SetSelectedEquipment(weapon, equipment)
        self.selectedWeapon = weapon
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
end
