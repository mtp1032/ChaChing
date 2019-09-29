--------------------------------------------------------------------------------------
-- SellItems.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 14 June, 2019
--------------------------------------------------------------------------------------
local ADDON_C_NAME, MTP = ...
MTP.SellItems = {}
cha = MTP.SellItems

local L = MTP.L
local E = errors

function cha:CHACHING_InitializeOptions()
 
    local ConfigurationPanel = CreateFrame("FRAME","CHACHING_MainFrame")
    ConfigurationPanel.name = L["ADDON_NAME"]
    InterfaceOptions_AddCategory(ConfigurationPanel)    -- Register the Configuration panel with LibUIDropDownMenu

    -- Print a header at the top of the panel
    local IntroMessageHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    IntroMessageHeader:SetPoint("TOPLEFT", 10, -10)
    IntroMessageHeader:SetText(L["ADDON_NAME_AND_VERSION"])
 
    local AuthorSubHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormal")
    AuthorSubHeader:SetPoint("TOPLEFT", 20, -30)
    AuthorSubHeader:SetText("Author: Shadowraith@Feathermoon")
 
    local DescrSubHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    DescrSubHeader:SetPoint("TOPLEFT", 20, -50)
    DescrSubHeader:SetText("Enables the bulk selling of selected items in player's inventory.")
        
    local ReadmeMessageText = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    ReadmeMessageText:SetPoint("TOPLEFT", 10, -320)
    ReadmeMessageText:SetText(strjoin("\n",
        "                    *** IMPORTANT ***                               ",
        "The merchant buyback window only has 12 slots. However, the merchant",
        "will buy as many items as Cha-Ching is configured to sell. So, if more",
        "than 12 items were sold, you will only be able to buyback the last 12"
    ))

    -- Create check button to sell grey items
    local GreyQualityButton = CreateFrame("CheckButton", "CHACHING_GreyQualityButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate")
    GreyQualityButton:SetPoint("TOPLEFT", 20, -80)
    GreyQualityButton.tooltip = "Sell all poor quality (i.e., grey) items in your bags."
	_G[GreyQualityButton:GetName().."Text"]:SetText("Sell Grey Items?")
	GreyQualityButton:SetChecked( sellGrey )
	GreyQualityButton:SetScript("OnClick", 
		function(self)
			sellGrey = self:GetChecked() and true or false
			print( sellGrey )
    	end)
 
    -- Create check button to sell white items
    local WhiteQualityButton = CreateFrame("CheckButton", "CHACHING_WhiteQualityButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate")
    WhiteQualityButton:SetPoint("TOPLEFT", 200, -80)
    WhiteQualityButton.tooltip = "Sell all common quality (i.e., white) armor and weapon items in your bags."
	_G[WhiteQualityButton:GetName().."Text"]:SetText("Sell White Items?")
	WhiteQualityButton:SetChecked( sellWhite )
	WhiteQualityButton:SetScript("OnClick", function(self)
		sellWhite = self:GetChecked() and true or false
		print( sellWhite )
    end)
 
    -- Create bag select buttons
    local bagsText = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormal")
    bagsText:SetPoint("TOPLEFT", 20, -200)
    bagsText:SetText("Select a bag. All items in the selected bag will be sold!")

    local xpos = 20
    local ypos = -215
    local delta_y = -20

    local function BagSelectButtonOnClick(self)
        isBagChecked[self.bagIndex] = self:GetChecked() and true or false
    end

    local bagSelectButtons = { } 
    for id = 0, 4 do
        local bagIndex = id + 1
        local button = CreateFrame("CheckButton", "CHACHING_BagButton" .. bagIndex, ConfigurationPanel, "ChatConfigCheckButtonTemplate")
        button:SetPoint("TOPLEFT", xpos, ypos + (delta_y * id))
        button.label = _G[button:GetName() .. "Text"]
        button.bagIndex = bagIndex
        button:SetScript("OnClick", BagSelectButtonOnClick)
        bagSelectButtons[bagIndex] = button
    end

	local function UpdateBagSelectButtons()
		for id = 0, 4 do
			local labelStr = nil
			local button = bagSelectButtons[id + 1]
			local numBagSlots = GetContainerNumSlots( id )
			if numBagSlots > 0 then
				local b = bg:getBag(id + 1)
				labelStr = string.format("Bag[%d] - %d free slots", id+1, GetContainerNumFreeSlots(id) )
				button.label:SetText(labelStr)
				button:SetEnabled(true)
			else
				local labelStr = string.format("Bag[%d] - Slot empty", id+1)
				button.label:SetText(labelStr)
				button:SetEnabled(false)
			end
        end
	end
	UpdateBagSelectButtons()

    ConfigurationPanel:SetScript("OnEvent", UpdateBagSelectButtons)

    ConfigurationPanel:SetScript("OnHide", function(self)
        self:UnregisterEvent("BAG_UPDATE")
    end)

    ConfigurationPanel:SetScript("OnShow", function(self)
        self:RegisterEvent("BAG_UPDATE")
        UpdateBagSelectButtons()
    end)

end
--------------------------------------------------------------------------------------
--						QUALITY (i.e., RARITY) values
--						are defuned in SlotClass.lua
--------------------------------------------------------------------------------------
local function itemCanBeSold( itemLink )
	local itemIsSaleable = false

	-- Setup the logic for selling/not selling POOR items
	item = Item( itemLink )
	local quality = item:getQuality()

	if quality == QUALITY_POOR and sellGrey then
		itemIsSaleable = true
	end

	if quality == QUALITY_COMMON and sellWhite then		
		-- At this point the item is white (COMMON) AND the user has set the sellAllWhiteItems flag to true.
		-- Now, make sure that it is either an armor piece or a weapon.
		local itemType = item:getType()
		if itemType == "Armor" or itemType == "Weapon" then
			itemIsSaleable = true
		end
	end
	return itemIsSaleable
end

-- called when the player clicks on the [Sell Items] button
local function sellItems()
	local totalEarnings = 0
	local numItemsSold = 0

	for bagSlot = 0, 4 do
		local totalSlots = GetContainerNumSlots( bagSlot )
		if totalSlots > 0 then
			-- Bet the total number of slots for this bag, but also 
			-- check that there is a valid bag installed at this slot. If
			-- the bag slot is empty then GetContainerNumSlots() returns 0
			local b = bg:getBag(bagSlot+1)
			-- did the player select this bag?
			if isBagChecked[bagSlot+1] then
				numItemsSold, totalEarnings = b:sellAllItemsInBag()
				print( string.format("items sold %d, total earnings %d", numItemsSold, totalEarnings ))
			else -- the bag is not checked. So, check for grays and whites
				for slotId = 1, totalSlots do
					local slot = Slot(b:getInstallationSlot(), slotId )	
					local itemCount = slot:getItemCount()
					if itemCount > 0 then				
						local itemLink = slot:getItemLink()
						if itemCanBeSold( itemLink ) then
							local unitSalesPrice = item:getUnitSalesPrice()
							UseContainerItem( bagSlot, slotId )
							totalEarnings = totalEarnings + unitSalesPrice * itemCount
							numItemsSold = numItemsSold + 1
						end -- if itemCanBeSold
					end -- if count
				end -- for slot = 1 ...
			end -- if bagChecked/else
		end -- if totalSlots
	end -- for bagSlot

	local msg = nil
	if numItemsSold > 1 then
		msg = string.format("%d transactions earned %s\n", numItemsSold, GetCoinTextureString( totalEarnings ))
	elseif numItemsSold == 1 then
		msg = string.format("%d transaction earned %s\n", numItemsSold, GetCoinTextureString( totalEarnings ))
	else
		msg = string.format("No items sold")	
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end

-- Creates a button frame within the Merchant frame.

local ButtonChaChing = CreateFrame( "Button" , "ChaChingBtn" , MerchantFrame, "UIPanelButtonTemplate" )
ButtonChaChing:SetText("ChaChing")
ButtonChaChing:SetWidth(90)
ButtonChaChing:SetHeight(21)
ButtonChaChing:SetPoint("TopRight", -180, -30 )
ButtonChaChing:RegisterForClicks("AnyUp")		
ButtonChaChing:SetScript("Onclick", sellItems )
