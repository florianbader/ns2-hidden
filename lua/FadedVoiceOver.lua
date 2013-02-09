// ===================== Faded Mod =====================
//
// lua\FadedVoiceOver.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

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

// Variables need to be global, so we don't have to overwrite the voice over functions,
// but they still can access them

kVoiceId = enum({
    'Ping', 
    'MarineTaunt', 'MarineCovering', 'MarineFollowMe', 'MarineHostiles', 'MarineLetsMove',
    'AlienTaunt', 'AlienChuckle', 'AlienScream'
})    

kSoundData = {
    [kVoiceId.Ping] = { Function = PingInViewDirection, Description = "REQUEST_PING", KeyBind = "PingLocation" },
    
    [kVoiceId.MarineTaunt] = { Sound = "sound/NS2.fev/marine/voiceovers/taunt", Description = "REQUEST_MARINE_TAUNT", KeyBind = "Taunt", AlertTechId = kTechId.None },
    [kVoiceId.MarineCovering] = { Sound = "sound/NS2.fev/marine/voiceovers/covering", Description = "REQUEST_MARINE_COVERING", AlertTechId = kTechId.None },
    [kVoiceId.MarineFollowMe] = { Sound = "sound/NS2.fev/marine/voiceovers/follow_me", Description = "REQUEST_MARINE_FOLLOWME", AlertTechId = kTechId.None },
    [kVoiceId.MarineHostiles] = { Sound = "sound/NS2.fev/marine/voiceovers/hostiles", Description = "REQUEST_MARINE_HOSTILES", AlertTechId = kTechId.None },
    [kVoiceId.MarineLetsMove] = { Sound = "sound/NS2.fev/marine/voiceovers/lets_move", Description = "REQUEST_MARINE_LETSMOVE", AlertTechId = kTechId.None }, 

    [kVoiceId.AlienTaunt] = { Sound = "", Function = GetLifeFormSound, Description = "REQUEST_ALIEN_TAUNT", KeyBind = "Taunt", AlertTechId = kTechId.None },
    [kVoiceId.AlienChuckle] = { Sound = "sound/NS2.fev/alien/voiceovers/chuckle", Description = "REQUEST_ALIEN_CHUCKLE", AlertTechId = kTechId.None },        
}

kMarineMenu =
{
    [LEFT_MENU] = { kVoiceId.Ping, kVoiceId.MarineLetsMove, kVoiceId.MarineFollowMe },
    [RIGHT_MENU] = { kVoiceId.MarineTaunt, kVoiceId.MarineCovering, kVoiceId.MarineHostiles }
}

kAlienMenu =
{
    [LEFT_MENU] = { kVoiceId.AlienTaunt },
    [RIGHT_MENU] = { kVoiceId.AlienChuckle }    
}

kRequestMenus = {
    ["Marine"] = kMarineMenu,
    ["JetpackMarine"] = kMarineMenu,
    ["Fade"] = kAlienMenu
}

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