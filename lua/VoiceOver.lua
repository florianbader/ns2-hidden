LEFT_MENU = 1
RIGHT_MENU = 2
kMaxRequestsPerSide = 5

Script.Load("lua/FadedVoiceOver.lua")

kAlienTauntSounds =
{
    [kTechId.Skulk] = "sound/NS2.fev/alien/skulk/taunt",
    [kTechId.Gorge] = "sound/NS2.fev/alien/gorge/taunt",
    [kTechId.Lerk] = "sound/NS2.fev/alien/lerk/taunt",
    [kTechId.Fade] = "sound/NS2.fev/alien/fade/taunt",
    [kTechId.Onos] = "sound/NS2.fev/alien/onos/taunt",
    [kTechId.Embryo] = "sound/NS2.fev/alien/common/swarm",
}
for _, tauntSound in pairs(kAlienTauntSounds) do
    PrecacheAsset(tauntSound)
end

local function VoteEjectCommander(player)

    if player then
        GetGamerules():CastVoteByPlayer(kTechId.VoteDownCommander1, player)
    end    
    
end

local function VoteConcedeRound(player)

    if player then
        GetGamerules():CastVoteByPlayer(kTechId.VoteConcedeRound, player)
    end  
    
end

function GetLifeFormSound(player)

    if player and player:isa("Alien") then    
        return kAlienTauntSounds[player:GetTechId()] or ""    
    end
    
    return ""

end

local function PingInViewDirection(player)

    if player and (not player.lastTimePinged or player.lastTimePinged + 60 < Shared.GetTime()) then
    
        local activeWeapon = player:GetActiveWeapon()
    
        local startPoint = player:GetEyePos()
        local endPoint = startPoint + player:GetViewCoords().zAxis * 40        
        local trace = Shared.TraceRay(startPoint, endPoint,  CollisionRep.Default, PhysicsMask.Bullets, EntityFilterOne(player))        
        player:GetTeam():SetCommanderPing(trace.endPoint)
        player.lastTimePinged = Shared.GetTime()
        
    end

end

function GetVoiceSoundData(voiceId)
    return kSoundData[voiceId]
end

for _, soundData in pairs(kSoundData) do
    if soundData.Sound ~= nil and string.len(soundData.Sound) > 0 then
        PrecacheAsset(soundData.Sound)
    end
end

function GetRequestMenu(side, className)

    local menu = kRequestMenus[className]
    if menu and menu[side] then
        return menu[side]
    end
    
    return {}

end


if Client then

    function GetVoiceDescriptionText(voiceId)
        
        local descriptionText = ""   
        
        local soundData = kSoundData[voiceId]
        if soundData then
            descriptionText = Locale.ResolveString(soundData.Description)
        end
        
        return descriptionText
        
    end
    
    function GetVoiceKeyBind(voiceId)
        
        local soundData = kSoundData[voiceId]
        if soundData then
            return soundData.KeyBind
        end    
        
    end
    
end


local kAutoMarineVoiceOvers = {}
local kAutoAlienVoiceOvers = {}


// defines priority and rules as of when to trigger a sound effect
local function BuildVoiceOverRules()


end