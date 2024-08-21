--------------------------------------------------------------------------------------
-- MiniMapIcon.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 17 July, 2023
local _, ChaChing = ...
ChaChing = ChaChing or {}
ChaChing.MiniMap = {}
local minimap = ChaChing.MiniMap

local core = ChaChing.Core
local options = ChaChing.OptionsMenu
local item = ChaChing.Item

local L = ChaChing.L

-- register the addon with ACE
local addon = LibStub("AceAddon-3.0"):NewAddon(L["ADDON_NAME"], "AceConsole-3.0")
local ICON_CHACHING = 133785

-- The addon's icon state (e.g., position, etc.,) is kept in the ChaChingDB. Therefore
-- this is set as the ##SavedVariable in the .toc file
local ChaChingDB = LibStub("LibDataBroker-1.1"):NewDataObject(L["ADDON_NAME"],
	{
		type = "data source",
		text = L["ADDON_NAME"], 
		icon = ICON_CHACHING,
		OnTooltipShow = function( tooltip )
			tooltip:AddLine(L["ADDON_NAME_AND_VERSION"])
			tooltip:AddLine(L["LEFT_CLICK_FOR_OPTIONS_MENU"])
			tooltip:AddLine(L["RIGHT_CLICK_SHOW_EXCLUSION_TABLE"])
		end,
		OnClick = function(self, button ) 
			-- LEFT CLICK - Displays the options menu
			if button == "LeftButton" and not IsShiftKeyDown() then
				OpenAllBags()
				options:showOptionsPanel()
			end
			-- RIGHT CLICK - Displays a list of excluded items
			if button == "RightButton" and not IsShiftKeyDown() then
				item:showExcludedItems()
			end
		end,
	})

-- so far so good. Now, create the actual icon	
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ChaChingDB", 
					{ profile = { minimap = { hide = false, }, }, }) 
	icon:Register(L["ADDON_NAME"], ChaChingDB, self.db.profile.minimap) 
end

local fileName = "MiniMapIcon.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s loaded", fileName), 1.0, 1.0, 0.0 )
end
