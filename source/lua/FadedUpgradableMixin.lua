// ===================== Faded Mod =====================
//
// lua\FadedUpgradableMixin.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

UpgradableMixin.networkVars =
{
    upgrade1 = "enum kTechId",
    upgrade2 = "enum kTechId",
    upgrade3 = "enum kTechId",
    upgrade4 = "enum kTechId",
    upgrade5 = "enum kTechId",
    upgrade6 = "enum kTechId",
    upgrade7 = "enum kTechId",
    upgrade8 = "enum kTechId",
}

function UpgradableMixin:__initmixin()

    self.upgrade1 = kTechId.None
    self.upgrade2 = kTechId.None
    self.upgrade3 = kTechId.None
    self.upgrade4 = kTechId.None
    self.upgrade5 = kTechId.None
    self.upgrade6 = kTechId.None
    self.upgrade7 = kTechId.None
    self.upgrade8 = kTechId.None
    
end

function UpgradableMixin:GetUpgrades()

    local upgrades = { }
    
    if self.upgrade1 ~= kTechId.None then
        table.insert(upgrades, self.upgrade1)
    end
    if self.upgrade2 ~= kTechId.None then
        table.insert(upgrades, self.upgrade2)
    end
    if self.upgrade3 ~= kTechId.None then
        table.insert(upgrades, self.upgrade3)
    end
    if self.upgrade4 ~= kTechId.None then
        table.insert(upgrades, self.upgrade4)
    end
    if self.upgrade5 ~= kTechId.None then
        table.insert(upgrades, self.upgrade5)
    end
    if self.upgrade6 ~= kTechId.None then
        table.insert(upgrades, self.upgrade6)
    end
    if self.upgrade7 ~= kTechId.None then
        table.insert(upgrades, self.upgrade7)
    end
    if self.upgrade8 ~= kTechId.None then
        table.insert(upgrades, self.upgrade8)
    end
    
    return upgrades
    
end

function UpgradableMixin:GiveUpgrade(techId) 

    local upgradeGiven = false
    
    if not self:GetHasUpgrade(techId) then
    
        if self.upgrade1 == kTechId.None then
        
            self.upgrade1 = techId
            upgradeGiven = true
            
        elseif self.upgrade2 == kTechId.None then
        
            self.upgrade2 = techId
            upgradeGiven = true
            
        elseif self.upgrade3 == kTechId.None then
        
            self.upgrade3 = techId
            upgradeGiven = true
            
        elseif self.upgrade4 == kTechId.None then
        
            self.upgrade4 = techId
            upgradeGiven = true
            
        elseif self.upgrade5 == kTechId.None then
        
            self.upgrade5 = techId
            upgradeGiven = true
            
        elseif self.upgrade6 == kTechId.None then
        
            self.upgrade6 = techId
            upgradeGiven = true
            
        elseif self.upgrade7 == kTechId.None then
        
            self.upgrade7 = techId
            upgradeGiven = true
            
        elseif self.upgrade8 == kTechId.None then
        
            self.upgrade8 = techId
            upgradeGiven = true
          
        end
        
        assert(upgradeGiven, "Entity already has the max of eight upgrades.")
        
    end
    
    if upgradeGiven and self.OnGiveUpgrade then
        self:OnGiveUpgrade(techId)
    end
    
    return upgradeGiven
    
end

function UpgradableMixin:RemoveUpgrade(techId)

    local removed = false
    
    if self:GetHasUpgrade(techId) then
    
        if self.upgrade1 == techId then
        
            self.upgrade1 = kTechId.None
            removed = true
            
        elseif self.upgrade2 == techId then
        
            self.upgrade2 = kTechId.None
            removed = true
            
        elseif self.upgrade3 == techId then
        
            self.upgrade3 = kTechId.None
            removed = true
            
        elseif self.upgrade4 == techId then
        
            self.upgrade4 = kTechId.None
            removed = true
            
        elseif self.upgrade5 == techId then
        
            self.upgrade5 = kTechId.None
            removed = true
            
        elseif self.upgrade6 == techId then
        
            self.upgrade6 = kTechId.None
            removed = true
            
        elseif self.upgrade7 == techId then
        
            self.upgrade7 = kTechId.None
            removed = true
            
        elseif self.upgrade8 == techId then
        
            self.upgrade8 = kTechId.None
            removed = true
            
        end
        
    end
    
    return removed
    
end

function UpgradableMixin:ClearUpgrades()

    self.upgrade1 = kTechId.None
    self.upgrade2 = kTechId.None
    self.upgrade3 = kTechId.None
    self.upgrade4 = kTechId.None
    self.upgrade5 = kTechId.None
    self.upgrade6 = kTechId.None
    self.upgrade7 = kTechId.None
    self.upgrade8 = kTechId.None
    
end 

function GetHasSilenceUpgrade(callingEntity)
    return true
end    