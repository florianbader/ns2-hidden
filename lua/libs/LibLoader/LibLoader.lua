// ===================== LibLoader ======================
//
// LibLoader\LibLoader.lua
//
//    Created by: Rio (rio@myrio.de)
//
// ======================================================

local libLoaderMinor = 1

if (not LibLoader or LibLoader.minor < libLoaderMinor) then
    LibLoader = LibLoader or { libs = {}, minor = libLoaderMinor }    
    
    function LibLoader:GetLibrary(major)
        assert(type(major) == "string", "major needs to be a string")
        return LibLoader.libs[major]
    end
    
    function LibLoader:NewLibrary(major, minor)
        assert(type(major) == "string", "major needs to be a string")
        
        local minorNumber = type(minor) == "number" and minor or tonumber(minor:match("%d+"))        
        assert(type(minorNumber) == "number", "minor needs to contain a number")
        
        local storedLib = LibLoader.libs[major]
        
        if (storedLib and storedLib.__libLoaderMinor > minorNumber) then 
            return nil 
        end
        
        lib = { __libLoaderMinor = minor }
        self.libs[major] = lib
        return lib
    end
end   