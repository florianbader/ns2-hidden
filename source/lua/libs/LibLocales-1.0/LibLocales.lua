// ===================== LibLocales =====================
//
// LibLocales\LibLocales.lua
//
//    Created by: Rio (rio@myrio.de)
//
// =====================================================

local strgsub = string.gsub
local strformat = string.format

local LibLocalesMajor, LibLocalesMinor = "LibLocales-1.0", 1
local lib = LibCache:NewLibrary(LibLocalesMajor, LibLocalesMinor)
if (not lib) then return end

lib.locale = "enUS"
lib.locales = {}

function lib:SetLocale(locale)
    assert(type(locale) == "string", "locale needs to be a string")
    if (self.locales[locale]) then        
        self.locale = locale
    else
        Shared.Message(strformat("Locale '%s' was not found.", locale))
    end    
end

function lib:Initialize()
    local matchingFiles = { }
    Shared.GetMatchingFileNames("gamestrings/*.txt", false, matchingFiles)

    for _, localeFile in pairs(matchingFiles) do
        local locale = localeFile:match("gamestrings/(.+).txt")         
        self.locales[locale] = {}
        
        for line in io.lines(localeFile) do                
            line = line:match("^%s*(.*)")
            if (line and line:sub(1, 2) ~= "//" and line ~= "") then
                // I hate Lua regular expressions, this has to do for now
                line = strgsub(line, '\\"', 'GORGES_ARE_ADORABLE!')
                local key, value = line:match("([A-Za-z0-9_%-]+)%s*=%s*\"([^\"]*)\"")
                
                if (key) then  
                    if (value) then
                        value = strgsub(value, 'GORGES_ARE_ADORABLE!', '"')
                    end
                    
                    self.locales[locale][key] = value or ""
                end
            end
        end
    end    
end

function lib:ResolveString(name)
    assert(type(name) == "string", "name needs to be a string")
    return self.locales[self.locale][name]
end
    
lib:Initialize()