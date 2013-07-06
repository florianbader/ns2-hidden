// ===================== Faded Mod =====================
//
// lua\FadedVoiceOver.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

// Variables need to be global, so we don't have to overwrite the voice over functions,
// but they still can access them
kVoiceId = enum({
    'None', 'VoteEject', 'VoteConcede', 'Ping', 
    'MarineTaunt', 'MarineCovering', 'MarineFollowMe', 'MarineHostiles', 'MarineLetsMove',
    'AlienTaunt', 'AlienChuckle', 'AlienGrowl'
})    

kSoundData = {
    [kVoiceId.Ping] = { Function = PingInViewDirection, Description = "REQUEST_PING", KeyBind = "PingLocation" },
    
    [kVoiceId.MarineTaunt] = { Sound = "sound/NS2.fev/marine/voiceovers/taunt", Description = "REQUEST_MARINE_TAUNT", KeyBind = "Taunt", AlertTechId = kTechId.None },
    [kVoiceId.MarineCovering] = { Sound = "sound/NS2.fev/marine/voiceovers/covering", Description = "REQUEST_MARINE_COVERING", AlertTechId = kTechId.None },
    [kVoiceId.MarineFollowMe] = { Sound = "sound/NS2.fev/marine/voiceovers/follow_me", Description = "REQUEST_MARINE_FOLLOWME", AlertTechId = kTechId.None },
    [kVoiceId.MarineHostiles] = { Sound = "sound/NS2.fev/marine/voiceovers/hostiles", Description = "REQUEST_MARINE_HOSTILES", AlertTechId = kTechId.None },
    [kVoiceId.MarineLetsMove] = { Sound = "sound/NS2.fev/marine/voiceovers/lets_move", Description = "REQUEST_MARINE_LETSMOVE", AlertTechId = kTechId.None }, 

    [kVoiceId.AlienTaunt] = { Sound = "sound/NS2.fev/alien/fade/taunt", Description = "REQUEST_ALIEN_TAUNT", KeyBind = "Taunt", AlertTechId = kTechId.None },
    [kVoiceId.AlienChuckle] = { Sound = "sound/NS2.fev/alien/voiceovers/chuckle", Description = "REQUEST_ALIEN_CHUCKLE", AlertTechId = kTechId.None },      
    [kVoiceId.AlienGrowl] = { Sound = "sound/faded.fev/alien/voiceovers/growl", Description = "REQUEST_ALIEN_GROWL", AlertTechId = kTechId.None },       
}

kMarineMenu =
{
    [LEFT_MENU] = { kVoiceId.Ping, kVoiceId.MarineLetsMove, kVoiceId.MarineFollowMe },
    [RIGHT_MENU] = { kVoiceId.MarineTaunt, kVoiceId.MarineCovering, kVoiceId.MarineHostiles }
}

kAlienMenu =
{
    [LEFT_MENU] = { kVoiceId.AlienTaunt },
    [RIGHT_MENU] = { kVoiceId.AlienChuckle, kVoiceId.AlienGrowl }    
}

kRequestMenus = {
    ["Marine"] = kMarineMenu,
    ["JetpackMarine"] = kMarineMenu,
    ["Fade"] = kAlienMenu
}