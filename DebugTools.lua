--------------------------------------------------------------------------------------
-- DebugTools.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 9 March, 2021
--------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.DebugTools = {}	
dbg = ChaChing.DebugTools

local sprintf = _G.string.format  

local SUCCESS 			= core.SUCCESS 
local FAILURE 			= core.FAILURE
local EMPTY_STR 		= core.EMPTY_STR

---------------------------------------------------------------------------------------------------
--                      PUBLIC/EXPORTED FUNCTIONS
----------------------------------------------------------------------------------------------------
	function dbg:prefix( stackTrace )
		if stackTrace == nil then stackTrace = debugstack(2) end
		
		local pieces = {strsplit( ":", stackTrace, 5 )}
		local segments = {strsplit( "\\", pieces[1], 5 )}

		local fileName = segments[#segments]
		
		local strLen = string.len( fileName )
		local fileName = string.sub( fileName, 1, strLen - 2 )
		local names = strsplittable( "\/", fileName )
		local lineNumber = tonumber(pieces[2])
		local location = sprintf("[%s:%d] ", names[#names], lineNumber)
		return location
	end
	function dbg:print( str )
		local msg = nil
		if str ~= nil then
			if type( str ) ~= "string" then
				msg = tostring( str )
			else
				msg = str
			end
		else
			msg = EMPTY_STR
		end

		local fn = dbg:prefix( debugstack(2) )
		local s = nil
		if msg then
			s = sprintf("%s %s", fn, msg )
		else
			s = fn
		end
		DEFAULT_CHAT_FRAME:AddMessage( s, 0.0, 1.0, 1.0 )
	end	
	function dbg:setResult( errMsg, stackTrace )
		local result = { FAILURE, EMPTY_STR, EMPTY_STR }
		
		local fileLocation = dbg:prefix( stackTrace )
		errMsg = sprintf("%s %s\n", fileLocation, errMsg )
		result[2] = errMsg
		
		if stackTrace ~= nil then
			result[3] = stackTrace
		end
		return result
	end

local fileName = "DebugTools.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s loaded", fileName), 0.0, 1.0, 0.0 )
end

