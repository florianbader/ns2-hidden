// ===================== Faded Mod =====================
//
// lua\FadedFade.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

Script.Load("lua/FadedSwipeLeap.lua")
Script.Load("lua/FadedAcidRockets.lua")

if (Server) then
    Script.Load("lua/FadedFade_Server.lua")    
elseif (Client) then
    Script.Load("lua/FadedFade_Client.lua")        
end

Fade.kLeapForce = 22
Fade.kLeapTime = 0.2

local networkVars =
{
    isScanned = "boolean",
    shadowStepping = "boolean",
    timeShadowStep = "private time",
    shadowStepDirection = "private vector",
    hasDoubleJumped = "private compensated boolean",    
    landedAfterBlink = "private compensated boolean",    
    landedAfterBlink = "compensated boolean",    
    
    etherealStartTime = "private time",
    etherealEndTime = "private time",
    
    // True when we're moving quickly "through the ether"
    ethereal = "boolean",    
    
    // Wall grip. time == 0 no grip, > 0 when grip started.
    wallGripTime = "private compensated time",
    // the normal that the model will use. Calculated the same way as the skulk
    wallGripNormalGoal = "private compensated vector",    
    wallGripAllowed = "private compensated boolean",
    
    leaping = "compensated boolean",
    timeOfLeap = "private compensated time",
    timeOfLastJumpLand = "private compensated time",
}

AddMixinNetworkVars(BaseMoveMixin, networkVars)
AddMixinNetworkVars(GroundMoveMixin, networkVars)
AddMixinNetworkVars(CameraHolderMixin, networkVars)
AddMixinNetworkVars(DissolveMixin, networkVars)

// if the user hits a wall and holds the use key and the resulting speed is < this, grip starts
Fade.kWallGripMaxSpeed = 6
// once you press grip, you will slide for this long a time and then stop. This is also the time you
// have to release your movement keys, after this window of time, pressing movement keys will release the grip.
Fade.kWallGripSlideTime = 0.2
// after landing, the y-axis of the model will be adjusted to the wallGripNormal after this time.
Fade.kWallGripSmoothTime = 0.6

// how to grab for stuff ... same as the skulk tight-in code
Fade.kWallGripRange = 0.2
Fade.kWallGripFeelerSize = 0.25

kWallGripEnergyCost = 10

local onCreate = Fade.OnCreate
function Fade:OnCreate()       
    InitMixin(self, WallMovementMixin)
 
    onCreate(self)
    
    self.wallGripTime = 0
    
    self.leaping = false
    
    self.darkVisionEnabled = false
    self:SetDarkVision(true)
end

local fadeOnInitialize = Fade.OnInitialized
function Fade:OnInitialized()
    fadeOnInitialize(self)
    
    if (Client) then
        self:AddHelpWidget("FadedGUIFadeLeapHelp", kFadedModGUIHelpLimit)
        self:AddHelpWidget("FadedGUIFadeWallgripHelp", kFadedModGUIHelpLimit)
        self:AddHelpWidget("FadedGUIFadeVisionHelp", kFadedModGUIHelpLimit)
    end
end    

function Fade:SetDarkVision(state)
    Alien.SetDarkVision(self, state)
    self.darkVisionEnabled = state
end

function Fade:GetIsLeaping()
    return self.leaping
end

function Fade:GetIsWallGripping()
    return self.wallGripTime ~= 0 
end

function Fade:OverrideUpdateOnGround(onGround)
    return (onGround or self:GetIsWallGripping())
end

function Fade:GetCanStep()
    return self:GetIsOnGround() and not self:GetIsWallGripping()
end

function Fade:ModifyGravityForce(gravityTable)
    if self:GetIsWallGripping() or self:GetIsOnGround() then
        gravityTable.gravity = 0        
    elseif self:GetCrouching() then
        gravityTable.gravity = gravityTable.gravity * 4
        
    end
end

function Fade:OnWorldCollision(normal)
    self.wallGripAllowed = normal.y < 0.5 and not self:GetCrouching()
end

function Fade:HandleButtons(input)    
    local wallGripPressed = bit.band(input.commands, Move.MovementModifier) ~= 0 and bit.band(input.commands, Move.Jump) == 0
    
    if not self:GetIsWallGripping() and wallGripPressed and self.wallGripAllowed then

        // check if we can grab anything around us
        local wallNormal = self:GetAverageWallWalkingNormal(Fade.kWallGripRange, Fade.kWallGripFeelerSize)
        
        if wallNormal then
        
            self.wallGripTime = Shared.GetTime()
            self.wallGripNormalGoal = wallNormal
            self:SetVelocity(Vector(0,0,0))
            
        end
    
    else
        
        // we always abandon wall gripping if we flap (even if we are sliding to a halt)
        local breakWallGrip = bit.band(input.commands, Move.Jump) ~= 0 or input.move:GetLength() > 0 or self:GetCrouching() or bit.band(input.commands, Move.SecondaryAttack) ~= 0
        
        if breakWallGrip then
        
            self.wallGripTime = 0
            self.wallGripNormal = nil
            self.wallGripAllowed = false
            
        end
        
    end 
    
    Alien.HandleButtons(self, input)
end

function Fade:CalcWallGripSpeedFraction()

    local dt = (Shared.GetTime() - self.wallGripTime)
    if dt > Fade.kWallGripSlideTime then
        return 0
    end
    local k = Fade.kWallGripSlideTime
    return (k - dt) / k
    
end

local postUpdateMove = Fade.PostUpdateMove
function Fade:PostUpdateMove(input, runningPrediction)  
    postUpdateMove(self, input, runningPrediction)
 
    if (self:GetIsWallGripping()) then
        if (Shared.GetTime() > (self.wallGripTime + 0.08)) then        
            local energyCost = input.time * kWallGripEnergyCost
            if (self:GetEnergy() < energyCost) then
                self.wallGripTime = 0
                self.wallGripOrigin = nil
            else
                self:DeductAbilityEnergy(energyCost)        
            end    
        end
    end
        
    // wallgrip, recheck wallwalknormal as soon as the slide has stopped
    if self:GetIsWallGripping() and not self.wallGripRecheckDone and self:CalcWallGripSpeedFraction() == 0 then    
        self.wallGripNormalGoal = self:GetAverageWallWalkingNormal(Lerk.kWallGripRange, Lerk.kWallGripFeelerSize)
        self.wallGripRecheckDone = true
        
        if not self.wallGripNormalGoal then
            self.wallGripTime = 0
            self.wallGripOrigin = nil
            self.wallGripRecheckDone = false
        end        
    end
    
    if self.leaping and self:GetIsOnGround() and (Shared.GetTime() > self.timeOfLeap + Fade.kLeapTime) then
        self.leaping = false
    end
end

function Fade:OnLeap()
    local newVelocity = self:GetViewCoords().zAxis * self.kLeapForce * 1
    self:SetVelocity(newVelocity)  
    
    self.leaping = true
    self.onGround = false
    self.onGroundNeedsUpdate = true
    
    self.timeOfLeap = Shared.GetTime()
    self.timeOfLastJump = Shared.GetTime()        
end

function Fade:GetAirMoveScalar()

    if self:GetVelocityLength() < 8 then
        return 1.0
    elseif self.leaping then
        return 0.3
    end
    
    return 0
end

function Fade:GetCanBeSetOnFire()
    return kFadedModFadeCanBeSetOnFire
end   

// No shadow step!
function Fade:TriggerShadowStep(direction)
end

// Make the Faded silent
function Alien:UpdateSilenceLevel()
    self.silenceLevel = 3
end    

function Fade:UpdateSilenceLevel()
    self.silenceLevel = 3
end    

function Fade:GetEffectParams(tableParams)
    tableParams[kEffectFilterSilenceUpgrade] = true
end    

function Alien:GetEffectParams(tableParams)
    tableParams[kEffectFilterSilenceUpgrade] = true
end    

Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars)