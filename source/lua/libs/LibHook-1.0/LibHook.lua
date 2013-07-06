// ===================== LibHook ====================
//
// LibHook\LibHook.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ==================================================

local libHookMajor, libHookMinor = "LibHook-1.0", 1
local lib = LibCache:NewLibrary(libHookMajor, libHookMinor)
if (not lib) then return end

local gsub = string.gsub
local tinsert = table.insert

//Shared.LinkClassToMap("XenocideLeap", XenocideLeap.kMapName, networkVars)

lib.hookedFunctions = {}
lib.preHooks = {}
lib.postHooks = {}
lib.replaceHooks = {}

function lib:GetFunctionByName(hookedFunction) 
    if (self.hookedFunctions[hookedFunction]) then
        return self.hookedFunctions[hookedFunction]
    end

    // Get every part of the function name.
    local hookedFunctionList = {}
    gsub(hookedFunction, "([A-Za-z0-9]+)\.?\:?", function (name)
        tinsert(hookedFunctionList, name)
    end)
    
    // If we only have one part, it's a single function, not a class method.        
    if (#hookedFunctionList == 1) then
        local funcName = hookedFunctionList[0]
        local func = _G[funcName]
        return func and type(func) == "function" and func or nil      
    else
        local className = hookedFunctionList[0]
        local classTable = _G[className]
        
        if (not classTable) then return nil end
        for i = 2, #hookedFunctionList - 1 do
            local funcName = hookedFunctionList[i]
            
            if (type(classTable) ~= "table" or not classTable[funcName]) then return nil end
            classTable = classTable[funcName]
        end
        
        local func = classTable                
        return func and type(func) == "function" and func or nil   
    end
end

function lib:Post(hookedFunction, postFunction)
    assert(type(hookedFunction) == "string", "The hooked function needs to be a string")
    assert(type(postFunction) == "function", "The post function needs to be a function")   

    func = self:GetFunctionByName(hookedFunction) 
    assert(type(func) == "function", "The hooked function was not found")
    
    // Save the original function.
    if (not self.hookedFunctions[hookedFunction]) then
        self.hookedFunctions[hookedFunction] = { originalFunction = func, newFunction = function() lib:Call(hookedFunction) end }
    end
    
    // Save the pre-function.
    local postHooks = self.postHooks[hookedFunction] or {}
    tinsert(postHooks, postFunction)
    self.postHooks[hookedFunction] = postHooks
end

function lib:Pre(hookedFunction, preFunction, modifyParameters)
    modifyParameters = modifyParameters or false
    assert(type(hookedFunction) == "function", "The hooked function needs to be a function")
    assert(type(preFunction) == "function", "The pre function needs to be a function")
    assert(type(modifyParameters) == "boolean", "modifyParameters needs to be a boolean")
        
    func = self:GetFunctionByName(hookedFunction) 
    assert(type(func) == "function", "The hooked function was not found")

    // Save the original function.
    if (not self.hookedFunctions[hookedFunction]) then
        self.hookedFunctions[hookedFunction] = { originalFunction = func, newFunction = function() lib:Call(hookedFunction) end }
    end
    
    // Save the pre-function.
    local preHooks = self.preHooks[hookedFunction] or {}
    tinsert(preHooks, { func = preFunction, modifyParameters = modifyParameters })
    self.preHooks[hookedFunction] = preHooks
end

function lib:Replace(hookedFunction, replaceFunction)
    assert(type(hookedFunction) == "string", "The hooked function needs to be a string")
    assert(type(replacedFunction) == "function", "The replace function needs to be a function")   

    func = self:GetFunctionByName(hookedFunction) 
    assert(type(func) == "function", "The hooked function was not found")
    
    // Save the original function.
    if (not self.hookedFunctions[hookedFunction]) then
        self.hookedFunctions[hookedFunction] = { originalFunction = func, newFunction = function(...) lib:Call(hookedFunction, ...) end }
    end
    
    // Save the pre-function.
    local replaceHooks = self.replaceHooks[hookedFunction] or {}
    tinsert(replaceHooks, replaceFunction)
    self.replaceHooks[hookedFunction] = replaceHooks
end

function lib:Call(hookedFunction, ...)
    if (not self.hookedFunctions[hookedFunction]) then return end
    
    local preHooks = self.preHooks[hookedFunction]
    if (preHooks) then
        for i = 1, #preHooks do
            preHooks[i](...)
        end
    end
end
