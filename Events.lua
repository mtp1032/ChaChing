-- Events.lua
-- Event handling and initialization for ChaChing

ChaChing = ChaChing or {}
ChaChing.Events = {}

local events = ChaChing.Events
local core = ChaChing.Core
local dbg = ChaChing.DebugTools
local L = ChaChing.L

-- Access WoWThreads
local threadLib = LibStub:GetLibrary("WoWThreads", true)
if not threadLib then
    error("ChaChing: WoWThreads library is required but not found!")
end

-- ================================================================
-- Event Frame
-- ================================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

local function OnEvent(self, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == "ChaChing" then
        -- Initialize the addon once it's fully loaded
        if core and core.Initialize then
            core:Initialize()
        end
        DEFAULT_CHAT_FRAME:AddMessage(L["ADDON_NAME_AND_VERSION"], 0, 1, 0)

        eventFrame:UnregisterEvent("ADDON_LOADED")
    end
end

eventFrame:SetScript("OnEvent", OnEvent)

-- ================================================================
-- Public Event Registration Helpers (for future use)
-- ================================================================
function events:RegisterEvent(eventName, handler)
    eventFrame:RegisterEvent(eventName)
    -- You can expand this later with a proper event map
end

function events:UnregisterEvent(eventName)
    eventFrame:UnregisterEvent(eventName)
end

local fileName = "Events.lua"
DEFAULT_CHAT_FRAME:AddMessage(string.format("%s loaded", fileName), 0, 1, 0 )

--[[
-- ================================================================
-- Keep for testing)
-- ================================================================

local function helloWorldThread()
    local count = 0
    while count < 3 do
        dbg:print("Hello world from thread! Count:", count)
        threadLib:yield()
        count = count + 1
    end
    dbg:print("Hello world thread finished")
end

-- Start the test thread (comment this out when not needed)
-- local testThread = threadLib:create(30, helloWorldThread)
]]

