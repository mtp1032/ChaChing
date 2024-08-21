-- CommandLine.lua 
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 14 June, 2019
--------------------------------------------------------------------------------------
local ADDON_NAME, ChaChing = ...
ChaChing = ChaChing or {}
ChaChing.CommandLine = {}

local core = ChaChing.Core
local mf = ChaChing.MsgFrame
local dbg = ChaChing.DebugTools

local L = ChaChing.L

---------------------------------------------------------------------------------------------------
					--COMMAND LINE OPTIONS
--------------------------------------------------------------------------------------------------
-- Command line parsing: https://wowpedia.fandom.com/wiki/Creating_a_slash_command

local helpMsg = "Not Yet Implemented"

local function postHelpMsg()
    mf:postMsg(L["HELP_MESSAGE"] or helpMsg)
end

-- Command handler function
local function ChaChingCommands(optionStr, editbox)
    dbg:Print("Command received: " .. optionStr)

    -- Pattern matching that skips leading whitespace and whitespace between option and argList
    -- Any whitespace at end of the argList is retained
    local _, _, option, argList = string.find(optionStr, "%s?(%w+)%s?(.*)")
    dbg:Print("Option: " .. (option or "nil") .. ", Arguments: " .. (argList or "nil"))

    if option == nil or option == "help" or option == "" or option == '?' then
        postHelpMsg()
        return
    end

    option = string.lower(option)
    
    if option == "set" then
        if argList == "debug" then
            core:enableDebugging()
            mf:postMsg("Debugging enabled.")
            return
        end
    end

    -- If not handled above, display some sort of help message
    postHelpMsg()
end
  
SLASH_CHACHING1 = "/cc"
SlashCmdList["CHACHING"] = ChaChingCommands 

local fileName = "CommandLine.lua"
if core:debuggingIsEnabled() then
    DEFAULT_CHAT_FRAME:AddMessage(string.format("%s loaded", fileName), 1.0, 1.0, 0.0)
end
