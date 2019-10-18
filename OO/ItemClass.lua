-- --------------------------------------------------------------------------------------
-- ItemClass.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 5 June, 2019
--------------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.ItemClass = {}

local L = ChaChing.L
local E = errors
local sprintf = _G.string.format



------------------------------------- LOCAL CONSTANTS -----------------------------------------------------
-- indices into the itemDescr[iptor] table - the table returned by Blizzard's GetItemInfo()
local ITEMINFO_NAME                   = 1 -- string
local ITEMINFO_LINK                   = 2 -- string
local ITEMINFO_QUALITY                = 3 -- number (the quality of the item from 0 to 7)
local ITEMINFO_LEVEL                  = 4 -- number
local ITEMINFO_MIN_LEVEL              = 5 -- number (minimum iLevel to use the item, 0 is no level requirement)
local ITEMINFO_TYPE                   = 6 -- string ("Armor", "Weapon", "Key", "Quest", etc.)
local ITEMINFO_SUBTYPE                = 7 -- string ("Enchanting", "Cloth", etc.)
local ITEMINFO_STACK_COUNT            = 8 -- number
local ITEMINFO_EQUIP_LOC              = 9 -- string (see https://wow.gamepedia.com/API_GetItemInfo for description)
local ITEMINFO_ICON                   = 10 -- The icon texture for the item
local ITEMINFO_SELL_PRICE             = 11 -- number (in coppers)
local ITEMINFO_CLASS_ID               = 12 -- number (the numerical value that determines the string to display for 'itemType'.)
local ITEMINFO_SUBCLASS_ID            = 13 -- number (This is the numerical value that determines the string to display for 'itemSubType')
local ITEMINFO_BIND_TYPE              = 14 -- number (0 - none; 1 - on pickup; 2 - on equip; 3 - on use; 4 - quest)
local ITEMINFO_EXPAC_ID               = 15 -- ?
local ITEMINFO_SET_ID                 = 16 -- ?
local ITEMINFO_IS_CRAFTING_REAGENT    = 17 -- boolean (?)

QUALITY_POOR 		= 1
QUALITY_COMMON 		= 2
QUALITY_UNCOMMON 	= 3
QUALITY__RARE 		= 4
QUALITY__EPIC 		= 5
QUALITY_LEGENDARY 	= 6
QUALITY_ARTIFACT 	= 7
QUALITY_HEIRLOOM 	= 8

local qualityNames = {
	"QUALITY_POOR", 
	"QUALITY_COMMON", 
	"QUALITY_UNCOMMON", 
	"QUALITY_RARE", 
	"QUALITY_EPIC", 
	-- "QUALITY_LEGENDARY", 
	-- "QUALITY_ARTIFACT", 
	-- "QUALITY_HEIRLOOM", 
	-- "QUALITY_WOW TOKEN"
}

--***************************************************************************************************
--                                ITEM CONSTRUCTOR
--***************************************************************************************************
Item = ChaChing.ItemClass
Item.__index = Item

setmetatable(Item, {
    __index = Base,        -- makes the inheritance work
    __call = function (cls, ...)   --NOTE to me: 'cls' refers to the current table
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

-- variable can be an item link or a numeric identity (e.g., 30234 for Nordrassil Wrath-Kilt)
function Item:_init( itemLink )

	Base._init(self) 
	self.result = SUCCESSFUL_RESULT
	self.itemInfo = {}
	self.is_a = "GAME_ITEM"

	-- Check that the input varible is valid
	if itemLink == nil then
		self.result = E:setErrorResult(L["ARG_NIL"], debugstack() )
		return
	end
	if type( itemLink ) ~= "string" then
		if type(itemLink) ~= "number" then
			self.result = E:setErrorResult(L["ARG_WRONGTYPE"], debugstack() )
			return
		end
	end
	
	self.itemInfo 	=  { GetItemInfo( itemLink ) } -- BLIZZ
	if self.itemInfo == nil then
		self.result = E:setErrorResult(L["ITEM_NOT_YET_ENCOUNTERED"], debugstack())
		return
	end
	if self.itemInfo[ITEMINFO_NAME] == nil then
		self.result = E:setErrorResult(L["ARG_INVALID"], debugstack())
		return
	end
end
-----------------------------------------------------------------------------------------------------
--                                          ITEM METHODS
-- 	            see https://wow.gamepedia.com/API_GetContainerItemInfo for additional detail
-----------------------------------------------------------------------------------------------------
function Item:getResult()
    return self.result
end
function Item:getName()
    return self.itemInfo[ITEMINFO_NAME]
end
function Item:getLink()
    return self.itemInfo[ITEMINFO_LINK]
end
function Item:getNameAndLink()
    return self.itemInfo[ITEMINFO_NAME], self.itemInfo[ITEMINFO_LINK]
end
function Item:getStackCount()
	return self.itemInfo[ITEMINFO_STACK_COUNT]
end
function Item:getUnitSalesPrice()
    return self.itemInfo[ITEMINFO_SELL_PRICE]
end
function Item:getQualityName()
	local id = self.itemInfo[ITEMINFO_QUALITY]
	return qualityNames[id+1]
end
function Item:getQualityNameId()
	return self.itemInfo[ITEMINFO_QUALITY]
end
function Item:getItemLevel()
    return self.itemInfo[ITEMINFO_LEVEL]
end
function Item:getMinLevel()
    return self.itemInfo[ITEMINFO_MIN_LEVEL]
end
function Item:getType()
    return self.itemInfo[ITEMINFO_TYPE]
end
function Item:getSubType()
    return self.itemInfo[ITEMINFO_SUBTYPE]
end
function Item:getEquipLoc()
    return self.itemInfo[ITEMINFO_EQUIP_LOC]
end
function Item:getIcon()
    return self.itemInfo[ITEMINFO_ICON]
end
function Item:getClassId()
    return self.itemInfo[ITEMINFO_CLASS_ID]
end
function Item:getSubClassId()
    return self.itemInfo[ITEMINFO_SUBCLASS_ID]
end
function Item:getBindType()
    return self.itemInfo[ITEMINFO_BIND_TYPE]
end
function Item:isCraftingReagent()
    return self.itemInfo[ITEMINFO_IS_CRAFTING_REAGENT]
end
