// ===================== Hidden Mod =====================
//
// lua\HiddenConsoleCommands.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

local function OnCommandHidden(player)
    Shared.Message(string.format("Hidden mod: version %s", kHiddenModVersion or "error"))
end

Event.Hook("Console_hidden", OnCommandHidden)