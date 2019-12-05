----------------------------------------------------------------------------------------
-- BagClass.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 28 December, 2018
----------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.BagClass = {}

local L = ChaChing.L
local E = errors
local sprintf = _G.string.format

local exclusionTable = CHACHING_SAVED_VARS[3]
--------------------------------------------------------------------------------------------------
--              - The bagSlot is the location of the bag. For example, 0 represents the player's
--                  backpack
--              - The bagSlot is used to obtain the inventoryId. Player bags begin at inventoryId = 20
--              - NUM_BAG_SLOTS = 4, BAG_SLOT0 = the player's backpack
--              - NUM_BANKBAGSLOTS = 7
--              - bagSlot 0 is inventoryId = 20
--              - bagSlot 3 is inventoryId = 24
--------------------------------------------------------------------------------------------------

local POOR 				= 1
local COMMON			= 2
local CRAFTING 			= 3
local SOUL_BOUND 		= 4
local BY_BAG			= 5

local BACKPACK_SLOT_NUMBER = 0

-- bag types for Classical
local GENERAL_PURPOSE 	= 0 -- NOTE: for bags this means any item, for items it means no special bag type
local QUIVER 			= 1
local AMMO_POUCH 		= 2
local SOUL_SHARD 		= 4
local LEATHERWORKING 	= 8
local HERBALISM 		= 32
local ENCHANTING 		= 64 
local ENGINEERING 		= 128
local KEYRING 			= 256
local MINING 			= 1024
local UNKNOWN 			= 2048

local function getBagType( typeBitField )
  local bagType = "bad bit field"

  if typeBitField == QUIVER then
     bagType = "Quiver"
  elseif typeBitField == GENERAL_PURPOSE then
    bagType = "General Purpose"
  elseif typeBitField == AMMO_POUCH then
    bagType = "Ammo Pouch"
  elseif typeBitField == SOUL_SHARD then
    bagType = "Soul shard"
  elseif typeBitField == LEATHERWORKING then
    bagType = "Leather Working"
  elseif typeBitField == INSCRIPTION then
    bagType = "Inscription"
  elseif typeBitField == HERBALISM then
    bagType = "Herbalism"
  elseif typeBitField == ENCHANTING then
    bagType = "Enchanting"
  elseif typeBitField == ENGINEERING then
    bagType = "Engineering"
  elseif typeBitField == KEYRING then
    bagType = "Key Ring"
  elseif typeBitField == GEM then
    bagType = "Gem"
  elseif typeBitField == MINING then
    bagType = "Mining"
  elseif typeBitField == UNKNOWN then
    bagType = "Unknown"
  else 
    bagType = "Vanity"
  end 

  return bagType
end

-- Item = ChaChing.ItemClass
-- Item.__index = Item

-- setmetatable(Item, {
--     __index = Base,        -- makes the inheritance work
--     __call = function (cls, ...)   --NOTE to me: 'cls' refers to the current table
--     local self = setmetatable({}, cls)
--     self:_init(...)
--     return self
--   end,
-- })

-- variable can be an item link or a numeric identity (e.g., 30234 for Nordrassil Wrath-Kilt)
-- function Item:_init( itemLink )

-- 	Base._init(self) 
-- 	self.result = CHACHING_SUCCESSFUL_RESULT


--***************************************************************************************************
--                                BAG CONSTRUCTOR
--***************************************************************************************************
Bag = ChaChing.BagClass
Bag.__index = Bag

setmetatable(Bag, {
    __index = Base,                		-- Makes the inheritance work
    __call = function (cls, ...)        --NOTE to me: 'cls' refers to the current table
    local self = setmetatable({}, cls)
	self:_init(...)
    return self
  end,
})
function Bag:_init( bagSlot )   
		--          Inherited from the BaseClass parent
	Base._init(self)	
	self.result = CHACHING_SUCCESSFUL_RESULT
	self.is_a = "Bag"
	self.bagSlot = bagSlot
	self.totalSlots = GetContainerNumSlots( bagSlot )
	if( self.totalSlots == 0 ) then
		return
	end
	
	self.bagName = GetBagName( bagSlot )   -- BLIZZ
  	self.freeSlots, typeBitField = GetContainerNumFreeSlots( self.bagSlot )
	self.type = getBagType( typeBitField )
	self.isChecked = false
	
	self.slotTable = {}
	local slot
	for slotId = 1, self.totalSlots do
		slot = Slot( self.bagSlot, slotId )
		self.slotTable[slotId] = slot
	end

	-- see explanations here: 
    --      https://wow.gamepedia.com/API_ContainerIDToInventoryID and
    --      https://wow.gamepedia.com/API_GetBagName
    -- 
    --  Example USAGE:  Get the itemLink of the bag at bagSlot 1
    --      self.bagSlot = 1
    --      self.inventoryID = ContainerIDToInventoryID( self.bagSlot )  
    --      self.itemLink = GetInventoryItemLink("player",invID)
	if self.bagSlot ~= BACKPACK_SLOT_NUMBER then
		self.inventoryId = ContainerIDToInventoryID( self.bagSlot )
		self.itemLink = GetInventoryItemLink("Player", self.inventoryId )
	else
		self.bagName = GetBagName( bagSlot )
		self.inventoryId = nil
		self.itemLink = nil
	end
end
--***********************************************************************************************
--									GET / SET METHODS
--***********************************************************************************************
function Bag:updateSlots()
	for slotId = 1, self.totalSlots do
		self.slotTable[slotId] = Slot( self.bagSlot, slotId )
	end
end

function Bag:getResult()
	return self.result
end
function Bag:getSlot( slotId )
  return self.slotTable[slotId]
end
--							GET/SET METHODS
function Bag:bagType()    -- returns string value associated with self.type
  return self.type
end
function Bag:getItemLink()
    return self.itemLink
end
function Bag:inventoryId()
    return self.inventoryId
end
function Bag:getName()
    return self.bagName
end
function Bag:getTotalSlots()
   return self.totalSlots
end
function Bag:getNumFreeSlots()
   return self.freeSlots
end
function Bag:getInstallationSlot()
  return self.bagSlot
end
function Bag:setBagChecked( isChecked )
	self.isChecked = isChecked
end
function Bag:isBagChecked()
	return self.isChecked
end

local function itemIsOnExcludedList( itemLink )
	local itemName = GetItemInfo( itemLink )
	for key, value in pairs( CHACHING_SAVED_VARS[3] ) do
		if value == itemName then
			return true
		end
	end 
	return false
end
--***********************************************************************************************
--									Sell Methods
--***********************************************************************************************
function Bag:sellAllItemsInBag()
	local totalItemsSold = 0
	local totalEarnings = 0

	totalSlots = self.totalSlots
	for slotId = 1, totalSlots do
		local slot = self.slotTable[slotId]
		if slot ~= nil then
			local _, itemCount, _, _, _, _, itemLink = GetContainerItemInfo( self.bagSlot, slotId )
			if itemCount then
				if itemIsOnExcludedList( itemLink ) == false then -- it's not on the excluded list so sell it
					local item = Item( itemLink )

					-- no need to check the filters. We're gonna sell everything
					-- in this bag that can be sold (has a unit sales price)
					local unitSalesPrice = item:getUnitSalesPrice()
					if unitSalesPrice then
						UseContainerItem( self.bagSlot, slotId )
						self.slotTable[slotId] = Slot( self.bagSlot, slotId )
						totalEarnings = totalEarnings + unitSalesPrice * itemCount
						totalItemsSold = totalItemsSold + itemCount		

						self.slotTable[slotId] = GetContainerItemID( self.bagSlot, slotId )
					end
				end
			end -- end for loop
		end
	end
	return totalItemsSold, totalEarnings
end
