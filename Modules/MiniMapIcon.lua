--------------------------------------------------------------------------------------
-- MiniMapIcon.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 10 November, 2019
local _, ChaChing = ...
ChaChing.MiniMapIcon = {}
icon = ChaChing.MiniMapIcon

local L = ChaChing.L
local E = errors

local sprintf = _G.string.format

-- register the addon with ACE
local addon = LibStub("AceAddon-3.0"):NewAddon("ChaChing", "AceConsole-3.0")


local ICON_CHACHING = "Interface\\Icons\\inv_misc_coin_01"

-- The addon's icon state (e.g., position, etc.,) is kept in the ChaChingDB. Therefore
--  this is set as the ##SavedVariable in the .toc file
local ChaChingDB = LibStub("LibDataBroker-1.1"):NewDataObject("ChaChing",
	{
		type = "data source",
		text = "ChaChing",
		icon = ICON_CHACHING,
		OnTooltipShow = function( tooltip )
			tooltip:AddLine(L["ADDON_NAME_AND_VERSION"])
			tooltip:AddLine(L["LEFT_CLICK_FOR_OPTIONS_MENU"])
			tooltip:AddLine(L["RIGHT_CLICK_SHOW_EXCLUSION_TABLE"])
			tooltip:AddLine(L["SHIFT_RIGHT_CLICK_DELETE_EXCLUSION_TABLE"])		
		end,
		OnClick = function(self, button ) 
			-- LEFT CLICK - Displays the options menu
			if button == "LeftButton" and not IsShiftKeyDown() then
				si:showOptionsMenu()
			end
			-- RIGHT CLICK - Displays the exclusion table
			if button == "RightButton" and not IsShiftKeyDown() then
				si:showExclusionTable()
			end
			-- SHIFT RIGHT CLICK - Deletes the exclusion table
			if button == "RightButton" and IsShiftKeyDown() then
				si:clearExclusionTable()
			end
		end,
	})

-- so far so good. Now, create the actual icon	
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ChaChingDB", 
					{ profile = { minimap = { hide = false, }, }, }) 
	icon:Register("ChaChing", ChaChingDB, self.db.profile.minimap) 
end

-- What to do when the player clicks the minimap icon
local eventFrame = CreateFrame("Frame" )
eventFrame:RegisterEvent( "ADDON_LOADED")
eventFrame:SetScript("OnEvent", 
function( self, event, ... )
	local arg1, arg2, arg3 = ...

	if event == "ADDON_lOADED" and arg1 == "ChaChing" then
		addon:OnInitialize()
	end
end)
