// ===================== Faded Mod =====================
//
// lua\FadedMarine.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

if (Client) then
    local marineOnInitialize = Marine.OnInitialized
    function Marine:OnInitialized()
        marineOnInitialize(self)

        if (Client) then
            self:AddHelpWidget("FadedGUIMarineBuyHelp", kFadedModGUIHelpLimit)  
        end
    end    

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

    function Marine:FadedEquipmentMenuOpen()
        return self.fadedEquipmentMenu ~= nil
    end    

    function Marine:Buy()    
        // Don't allow display in the ready room
        if (self:GetTeamNumber() ~= 0 and Client.GetLocalPlayer() == self) then 
            if (not self.fadedEquipmentMenu) then         
                self.fadedEquipmentMenu = GetGUIManager():CreateGUIScript("FadedGUIMarineEquipmentMenu")        
                MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
            else            
                self:CloseMenu()
            end           
        end    
    end

    function Marine:CloseMenu()
        if (self.fadedEquipmentMenu) then
            GetGUIManager():DestroyGUIScript(self.fadedEquipmentMenu)
            self.fadedEquipmentMenu = nil
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
        Client:SendSelectEquipmentMessage()
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
