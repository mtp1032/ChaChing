-- CommandLine.lua
-- New replacement file for ChaChing

ChaChing = ChaChing or {}
ChaChing.CommandLine = ChaChing.CommandLine or {}

local SellEngine = ChaChing.SellEngine
local exclusion = ChaChing.Exclusion
local core = ChaChing.Core
local dbg = ChaChing.DebugTools
local utils = ChaChing.Utilities
local L = ChaChing.Localization


local function PrintHelp()
    print("|cffffd700ChaChing Commands:|r")
    print("  |cffffff00/chaching scan|r          - Scan bags and queue sellable items")
    print("  |cffffff00/chaching sell|r           - Sell all queued items (at merchant)")
    print("  |cffffff00/chaching test [verbose]|r  - Full decision scan (shows every item)")
    print("  |cffffff00/chaching status|r         - Show current queue count")
    print("  |cffffff00/chaching clear|r          - Clear sell queue")
    print("  |cffffff00/chaching debug on/off|r   - Toggle debugging")
    print("  |cffffff00/chaching help|r           - Show this help")
end

-- Main slash command handler
local function ChatCommandHandler(msg)
    if not msg or msg == "" then
        PrintHelp()
        return
    end

    local cmd, arg = strsplit(" ", strlower(msg), 2)

    if cmd == "sell" or cmd == "s" then
        ChaChing.SellEngine:Execute()

    elseif cmd == "scan" then
        local count = ChaChing.SellTable:ScanAndQueue()
        print(string.format("|cffffd700ChaChing:|r Scan complete — %d items queued for sale.", count))

elseif cmd == "test" then
    local verbose = arg and strlower(arg) == "verbose"
    if ChaChing.TestEntireBag then
        ChaChing.TestEntireBag(verbose)
    else
        print("|cffff0000ChaChing:|r TestEntireBag function not found. Check load order.")
    end
    elseif cmd == "status" or cmd == "queue" then
        local count = ChaChing.SellTable:GetCount()
        print(string.format("|cffffd700ChaChing:|r %d item(s) currently queued for sale.", count))
        if count > 0 and ChaChing.Core:debuggingIsEnabled() then
            for _, item in ipairs(ChaChing.SellTable.Items) do
                dbg.print(string.format("  %s → %s", item.link, item.reason))
            end
        end

    elseif cmd == "clear" then
        ChaChing.SellTable:Clear()
        print("|cffffd700ChaChing:|r Sell queue cleared.")

    elseif cmd == "debug" then
        if arg == "on" then
            ChaChing.Core:enableDebugging()
            print("|cffffd700ChaChing:|r Debugging enabled.")
        elseif arg == "off" then
            ChaChing.Core:disableDebugging()
            print("|cffffd700ChaChing:|r Debugging disabled.")
        else
            local state = ChaChing.Core:debuggingIsEnabled() and "ON" or "OFF"
            print("|cffffd700ChaChing:|r Debug is currently " .. state)
        end

    elseif cmd == "help" or cmd == "?" then
        PrintHelp()

    else
        print("|cffffd700ChaChing:|r Unknown command. Type |cffffff00/chaching help|r")
    end
end

-- Register slash commands
SLASH_CHACHING1 = "/chaching"
SLASH_CHACHING2 = "/cc"
SLASH_CHACHING3 = "/ching"
SLASH_CHACHING4 = "/cha"

SlashCmdList["CHACHING"] = ChatCommandHandler

-- Optional: Auto-scan when opening merchant (can be toggled later via options)
local function OnMerchantShow()
    if CHACHING_SAVED_OPTIONS and CHACHING_SAVED_OPTIONS.AutoScan then
        C_Timer.After(0.5, function()
            ChaChing.SellTable:ScanAndQueue()
        end)
    end
end

-- Register events (add more as needed)
local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        OnMerchantShow()
    end
end)

-- Print load message
if core:debuggingIsEnabled() then
    DEFAULT_CHAT_FRAME:AddMessage("CommandLine.lua loaded", 0, 1, 0)
end