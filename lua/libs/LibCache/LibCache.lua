// ===================== LibCache ======================
//
// LibCache\LibCache.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

local libCacheMinor = 1

if (not LibCache or LibCache.minor < libCacheMinor) then
    LibCache = LibCache or { libs = {}, minor = libCacheMinor }    
    
    function LibCache:GetLibrary(major)
        assert(type(major) == "string", "major needs to be a string")
        return LibCache.libs[major]
    end
    
    function LibCache:NewLibrary(major, minor)
        assert(type(major) == "string", "major needs to be a string")
        
        local minorNumber = type(minor) == "number" and minor or tonumber(minor:match("%d+"))        
        assert(type(minorNumber) == "number", "minor needs to contain a number")
        
        local storedLib = LibCache.libs[major]
        
        if (storedLib and storedLib.__libCacheMinor > minorNumber) then 
            return nil 
        end
        
        lib = { __libCacheMinor = minor }
        self.libs[major] = lib
        return lib
    end
end   