// ===================== Faded Mod =====================
//
// lua\FadedConsoleCommands.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local function OnCommandFaded(player)
    Shared.Message(string.format("Faded mod: version %s", kFadedModVersion or "error"))
end

Event.Hook("Console_faded", OnCommandFaded)