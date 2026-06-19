--------------------------------------------------------------------------------------
-- ChaChing = ChaChing or {}
-- Author: mtpeterson1948@gmail.com
-- Date: 17 June, 1948
-------------------------------------------------------------

ChaChing.Events = ChaChing.Events or {}
local events = ChaChing.Events
local core = ChaChing.Core
local dbg = ChaChing.dbg
local L = ChaChing.L


-- Access WoWThreads using LibStub
local thread = LibStub:GetLibrary("WoWThreads", true)
if not thread then
    print("Error: WoWThreads library not found!")
    return
end
local SIG_ALERT        = thread.SIG_ALERT
local SIG_TERMINATE    = thread.SIG_TERMINATE
local SIG_NONE_PENDING = thread.SIG_NONE_PENDING

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

local ADDON_NAME = select(1, ...)   -- this is the addon name passed to the file if it's an XML load, but usually not needed
local tocAddonName = core:getAddonInfo()  -- this is the addon name from the TOC, which is more reliable for checking against ADDON_LOADED
local function OnEvent(self, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == tocAddonName then
        DEFAULT_CHAT_FRAME:AddMessage(L["ADDON_LOADED_MESSAGE"], 0.0, 1.0, 0)
        eventFrame:UnregisterEvent("ADDON_LOADED")
    end
end

eventFrame:SetScript("OnEvent", OnEvent)local function hello()    
    local DONE = false
    local count = 0

    while not DONE do
        print( "Hello world.")
        thread:yield()
        count = count + 1
        if count == 3 then DONE = true end
    end
end

local thread_h = thread:create(30,  hello )

