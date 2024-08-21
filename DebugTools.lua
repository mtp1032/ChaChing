--------------------------------------------------------------------------------------
-- DebugTools.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 9 March, 2021
--------------------------------------------------------------------------------------
local ADDON_NAME, ChaChing = ...
ChaChing = ChaChing or {}
ChaChing.DebugTools = {}
local dbg = ChaChing.DebugTools
local core = ChaChing.Core

---------------------------------------------------------------------------------------------------
--                      PUBLIC/EXPORTED FUNCTIONS
----------------------------------------------------------------------------------------------------
function dbg:Prefix( stackTrace )
	if stackTrace == nil then stackTrace = debugstack(2) end
	
	local pieces = {strsplit( ":", stackTrace, 5 )}
	local segments = {strsplit( "\\", pieces[1], 5 )}

	local fileName = segments[#segments]
	
	local strLen = string.len( fileName )
	local fileName = string.sub( fileName, 1, strLen - 2 )
	local names = strsplittable( "\/", fileName )
	local lineNumber = tonumber(pieces[2])

	local prefix = string.format("[%s:%d] ", names[#names], lineNumber)
	return prefix
end
function dbg:Print(...)
    local prefix = dbg:Prefix( debugstack(2) )

    -- The '...' collects all extra arguments passed to the function
    local args = {...}  -- This creates a table 'args' containing all extra arguments

    -- Convert all arguments into strings to ensure proper formatting for print with
    -- the 'prefix' as the first element of the string to be printed.
    local output = {prefix}
    for i, v in ipairs(args) do
        table.insert(output, tostring(v))
    end

    -- Use the unpack function to pass all elements of 'output' as separate arguments 
    -- to the built-in print function
    _G.print(unpack(output))
end

local fileName = "DebugTools.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s loaded", fileName), 0.0, 1.0, 0.0 )
end

