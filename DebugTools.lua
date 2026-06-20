-- DebugTools.lua
-- Debug utilities for ChaChing

ChaChing = ChaChing or {}
if not ChaChing.enUS.loaded then
	DEFAULT_CHAT_FRAME:AddMessage("enUS.lua failed to load", 1, 0, 0)
    return
end
ChaChing.DebugTools = {}

local core = ChaChing.Core
local dbg = ChaChing.DebugTools
local L = ChaChing.L


-- ================================================================
-- Internal Helper
-- ================================================================
local function getDebugPrefix()
    local stack = debugstack(3)  -- Go one level deeper for better accuracy
    local file, line = stack:match("([%w_%.]+%.lua):(%d+)")

    if file and line then
        return string.format("[%s:%s] ", file, line)
    end

    return "[ChaChing:??] "
end

-- ================================================================
-- Public Debug Functions
-- ================================================================
function dbg:prefix()
    return getDebugPrefix()
end

function dbg:print(...)
    if not ChaChing.Core:IsDebuggingEnabled() then
        return
    end

    local prefix = getDebugPrefix()
    local args = {...}

    -- Convert everything to string and print with prefix
    local output = {prefix}
    for i, v in ipairs(args) do
        table.insert(output, tostring(v))
    end

    _G.print(unpack(output))
end

-- Quick toggle helpers
function dbg:enable()
    ChaChing.Core:enableDebugging()
end

function dbg:disable()
    ChaChing.Core:disableDebugging()
end

-- ================================================================
-- Load Confirmation
-- ================================================================
ChaChing.DebugTools.loaded = true

if core:debuggingIsEnabled() then
    DEFAULT_CHAT_FRAME:AddMessage("DebugTools.lua loaded", 0, 1, 0 )
end
ChaChing.DebugTools.loaded = true
return ChaChing.DebugTools.loaded