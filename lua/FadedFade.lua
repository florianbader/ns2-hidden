// ===================== Faded Mod =====================
//
// lua\FadedFade.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

Script.Load("lua/FadedSwipeLeap.lua")
//Script.Load("lua/TechData.lua")

if (Server) then
    Script.Load("lua/FadedFade_Server.lua")
end
/*
local tinsert = table.insert

local buildTechData = BuildTechData
function BuildTechData()
    techData = buildTechData()
    tinsert(techData, { [kTechDataId] = kTechId.SwipeLeap, [kTechDataMapName] = SwipeLeap.kMapName, [kTechDataDamageType] = kSwipeDamageType, [kTechDataDisplayName] = "SWIPE_LEAP", [kTechDataTooltipInfo] = "SWIPE_TOOLTIP" })
    return techData
end

kTechData = BuildTechData() 
*/

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
    // if we have done our wall normal recheck (when we stop sliding)
    wallGripRecheckDone = "private compensated boolean",
    // if wallChecking is enabled. Means that the next time you press use
    wallGripCheckEnabled = "private compensated boolean",
    
    leaping = "compensated boolean",
    timeOfLeap = "private compensated time",
    timeOfLastJumpLand = "private compensated time",
}

AddMixinNetworkVars(BaseMoveMixin, networkVars)
AddMixinNetworkVars(GroundMoveMixin, networkVars)
AddMixinNetworkVars(CameraHolderMixin, networkVars)
AddMixinNetworkVars(DissolveMixin, networkVars)

// if the user hits a wall and holds the use key and the resulting speed is < this, grip starts
Fade.kWallGripMaxSpeed = 4
// once you press grip, you will slide for this long a time and then stop. This is also the time you
// have to release your movement keys, after this window of time, pressing movement keys will release the grip.
Fade.kWallGripSlideTime = 0.7
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
    self.wallGripRecheckDone = false
    self.wallGripCheckEnabled = false
    
    self.leaping = false
end

function Fade:GetIsWallGripping()
    return self.wallGripTime ~= 0 
end

function Fade:HandleButtons(input)

    Alien.HandleButtons(self, input)
    
    if not self:GetIsWallGripping()  then
        if bit.band(input.commands, Move.Jump) ~= 0 then
            
            if self.wallGripCheckEnabled then
        
                if not self:GetIsOnGround() then
                    // check if we can grab anything around us
                    local wallNormal = self:GetAverageWallWalkingNormal(Fade.kWallGripRange, Fade.kWallGripFeelerSize)
                    
                    if wallNormal then
                    
                        self.wallGripTime = Shared.GetTime()
                        self.wallGripNormalGoal = wallNormal
                        self.wallGripRecheckDone = false
                        self:SetVelocity(Vector(0,0,0))
                        
                    end
                    
                end
                
                // we clear the wallGripCheckEnabled here to make sure we don't trigger a flood of TraceRays just because
                // we hold down the use key
                self.wallGripCheckEnabled = false
            
            end
        
        end
    
    else
        
        // we always abandon wall gripping if we blink or shadow step
        local breakWallGrip = bit.band(input.commands, Move.MovementModifier) ~= 0 or bit.band(input.commands, Move.SecondaryAttack) ~= 0
        
        // after sliding to a stop, pressing movment or crouch will drop the grip
        if not breakWallGrip and Shared.GetTime() - self.wallGripTime > Fade.kWallGripSlideTime then
            breakWallGrip = input.move:GetLength() > 0 or bit.band(input.commands, Move.Crouch) ~= 0 
        end
        
        if breakWallGrip then
            self.wallGripTime = 0
            self.wallGripNormal = nil
            self.wallGripRecheckDone = false
        end
        
    end
    
end

function Fade:CalcWallGripSpeedFraction()

    local dt = (Shared.GetTime() - self.wallGripTime)
    if dt > Fade.kWallGripSlideTime then
        return 0
    end
    local k = Fade.kWallGripSlideTime
    return (k - dt) / k
    
end

local updatePosition = Fade.UpdatePosition
function Fade:UpdatePosition(velocity, time)
    local requestedVelocity = Vector(velocity)
    
    if self:GetIsWallGripping() then   
        velocity = velocity * self:CalcWallGripSpeedFraction()
    end
    
    velocity = updatePosition(self, velocity, time)
    
    if not self:GetIsWallGripping() and not self.wallGripCheckEnabled then
        // if we bounced into something and we are not on the ground, we enable one
        // wall gripping on the next use use.
        // Lerks don't have any use other use for their use key, so this works in practice
        local deltaV = (requestedVelocity - velocity):GetLength()
        self.wallGripCheckEnabled = deltaV > 0 and not self:GetIsOnGround() 
    end
    
    return velocity
end 

local preUpdateMove = Fade.PreUpdateMove
function Fade:PreUpdateMove(input, runningPrediction)  
    preUpdateMove(self, input, runningPrediction)
 
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
    
    if self.leaping and Alien.GetIsOnGround(self) and (Shared.GetTime() > self.timeOfLeap + Fade.kLeapTime) then
        self.leaping = false
    end
end

function Fade:OnLeap()
    /* 
local velocity = self:GetVelocity() * 0.5    
    local minSpeed = math.max(0, Fade.kMinLeapVelocity - velocity:GetLengthXZ() - Fade.kLeapVerticalForce) * self:GetMovementSpeedModifier()

    local forwardVec = self:GetViewAngles():GetCoords().zAxis
    local newVelocity = (velocity + GetNormalizedVectorXZ(forwardVec) * (Fade.kLeapForce * self:GetMovementSpeedModifier() + minSpeed))
    
    // Add in vertical component.
    newVelocity.y = Fade.kLeapVerticalVelocity * forwardVec.y + Fade.kLeapVerticalForce * self:GetMovementSpeedModifier() + ConditionalValue(velocity.y < 0, velocity.y, 0)
    
    self:SetVelocity(newVelocity) 
    */         
            
    local newVelocity = self:GetViewCoords().zAxis * self.kLeapForce * self:GetMovementSpeedModifier() // + self:GetVelocity()
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

Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars)