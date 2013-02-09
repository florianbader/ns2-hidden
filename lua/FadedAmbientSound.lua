// ===================== Faded Mod =====================
//
// lua\FadedAmbientSound.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local random = math.random

local ambientBackgroundSounds = {
    { sound = "sound/faded.fev/ambient/clank", length = 12382 },
    { sound = "sound/faded.fev/ambient/alien_noise", length = 11415 },
    { sound = "sound/faded.fev/ambient/alien_noise2", length = 26409 },
}

local ambientFadedSounds = {
    { sound = "sound/faded.fev/ambient/whisper_tail1", length = 4234 },
    { sound = "sound/faded.fev/ambient/whisper_tail2", length = 3720 },
    { sound = "sound/faded.fev/ambient/whisper_tail3", length = 5605 },
}

for _, ambientSound in pairs(ambientBackgroundSounds) do
    Client.PrecacheLocalSound(ambientSound.sound)
end    

for _, ambientSound in pairs(ambientFadedSounds) do
    Client.PrecacheLocalSound(ambientSound.sound)
end   

local kAmbientBackgroundSoundInterval = 20
local lastAmbientBackgroundSoundPlayed = 0
local currentAmbientBackgroundSound = nil

local kAmbientFadedSoundInterval = 4
local lastAmbientFadedSoundPlayed = 0
local currentAmbientFadedSound = nil

local function OnUpdateClient(deltaTime)
    local player = Client.GetLocalPlayer()
    if (not player) then return end
    
    // Somehow the sound does still play if we have turned the volume to min
    if (OptionsDialogUI_GetSoundVolume() == 0) then return end

    if (Shared.GetTime() - lastAmbientBackgroundSoundPlayed >= kAmbientBackgroundSoundInterval) then
        currentAmbientBackgroundSound = ambientBackgroundSounds[random(#ambientBackgroundSounds)]
        lastAmbientBackgroundSoundPlayed = Shared.GetTime() + currentAmbientBackgroundSound.length / 1000
        Shared.PlaySound(player, currentAmbientBackgroundSound.sound)
    end
    
    if (player:isa("Marine")) then
        local nearbyFade = GetEntitiesWithinRange("Fade", player:GetOrigin(), kFadedModDistortionRadius)
        if (#nearbyFade > 0) then        
            if (Shared.GetTime() - lastAmbientFadedSoundPlayed >= kAmbientFadedSoundInterval) then
                currentAmbientFadedSound = ambientFadedSounds[random(#ambientFadedSounds)]
                lastAmbientFadedSoundPlayed = Shared.GetTime() + currentAmbientFadedSound.length / 1000
                Shared.PlaySound(player, currentAmbientFadedSound.sound)
            end
        end
    end    
end

Event.Hook("UpdateClient", OnUpdateClient)
 