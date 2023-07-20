--------------------------------------------------------------------------------------
-- CommandLine.lua 
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 14 June, 2019
--------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.CommandLine = {}
sell = ChaChing.CommandLine

local L = ChaChing.L
local sprintf = _G.string.format

---------------------------------------------------------------------------------------------------
					--COMMAND LINE OPTIONS
--------------------------------------------------------------------------------------------------
-- Command line parsing: https://wowpedia.fandom.com/wiki/Creating_a_slash_command

local function postHelpMsg()
end

-- https://wowwiki-archive.fandom.com/wiki/Creating_a_slash_command
local function validateCmd( msg )
    local isValid = true
    
    if msg == nil then
        isValid = false
    end
    if msg == EMPTY_STR then
        isValid = false
    end
    return isValid
end
local function ChaChingCommands(cmdStr, editbox)
	local result = {SUCCESS, EMPTY_STR, EMPTY_STR}

    -- pattern matching that skips leading whitespace and whitespace between cmd and args
    -- any whitespace at end of args is retained
    local _, _, cmd, args = string.find(cmdStr, "%s?(%w+)%s?(.*)")
    cmd = string.lower( cmd )
    if cmd == nil then
        print("Help not implemented yet")
        return
    end

    if cmd == "foo" then -- calls cleu:summarizeEncounter()
        print( "<call a function to do foo>" )
    end

    if cmd == "help" or cmd == "" then
        postHelpMsg( helpMsg )
        return
    end
        -- If not handled above, display some sort of help message
        postHelpMsg( helpMsg )
  end
  
  SLASH_CHACHING = "/cc"
  SlashCmdList["CHACHING1"] = chaChingCommands  -- adds "/monitor" to the commands list

local fileName = "CommandLine.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s loaded", fileName), 1.0, 1.0, 0.0 )
end
