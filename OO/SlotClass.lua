----------------------------------------------------------------------------------------
-- SlotClass.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 28 December, 2018
----------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.SlotClass = {}

local L = ChaChing.L
local E = errors
local sprintf = _G.string.format

-- indices into the itemInfo table - the table returned by GetContainerItemInfo()
local SLOTINFO_TEXTURE		= 1  -- number
local SLOTINFO_ITEM_COUNT		= 2  -- number
local SLOTINFO_IS_LOCKED		= 3  -- boolean
local SLOTINFO_QUALITY		= 4  -- number
local SLOTINFO_READABLE		= 5  -- boolean
local SLOTINFO_LOOTABLE		= 6  -- boolean
local SLOTINFO_ITEM_LINK		= 7  -- string
local SLOTINFO_IS_FILTERED	= 8  -- boolean
local SLOTINFO_OF_NOVALUE		= 9  -- boolean
local SLOTINFO_ITEMID			= 10 -- number

--------------------------------------------------------------------------------------------------
--                      Internal validation methods
--------------------------------------------------------------------------------------------------
local function validateSlotId (slotId, totalSlots )
    local result = CHACHING_DEFAULT_RESULT

	if slotId == nil then
        return E:setErrorResult(L["ARG_NIL"], debugstack() )
    end
	if type(slotId) ~= "number" then
        return E:setErrorResult(L["ARG_WRONGTYPE"], debugstack() )
    end
	if slotId < 1 then
        return E:setErrorResult(L["ARG_OUTOFRANGE"], debugstack() )
    end
    if slotId > totalSlots then
        return E:setErrorResult(L["ARG_OUTOFRANGE"], debugstack() )
    end
    return result
end
local function validateBagSlot( bagSlot )
    local result = CHACHING_DEFAULT_RESULT

    if bagSlot == nil then 
        return E:setErrorResult(L["ARG_NIL"], debugstack() )
    end
    if type(bagSlot) ~= "number" then
        return E:setErrorResult( L["ARG_WRONGTYPE"], debugstack() )
    end
    if bagSlot < 0 then
        return E:setErrorResult(L["ARG_OUTOFRANGE"], debugstack() )
    end 
    if bagSlot > 4 then
      return E:setErrorResult(L["ARG_OUTOFRANGE"], debugstack() )
    end

    return result
end

--***************************************************************************************************
--                                SLOT CONSTRUCTOR
--***************************************************************************************************
Slot = ChaChing.SlotClass
Slot.__index = Slot

setmetatable(Slot, {
    __index = Base,        -- makes the inheritance work
    __call = function (cls, ...)   --NOTE to me: 'cls' refers to the current table
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function Slot:_init(bagSlot, slotId )

    Base._init(self)               -- call the base class constructor

	-- Check that the slot number (= slotId) is well-formed
	self.item 		= nil
	self.is_a 		= "IS_INVENTORY_SLOT"
	self.slotId		= slotId
    self.bagSlot 	= bagSlot
	self.result 	= CHACHING_SUCCESSFUL_RESULT

	local totalSlots = GetContainerNumSlots( bagSlot )			-- BLIZZ
	local numFreeSlots = GetContainerNumFreeSlots( bagSlot )		-- BLIZZ
	self.result  = validateSlotId( slotId, totalSlots )
	if self.result[1] ~= CHACHING_STATUS_SUCCESS then
        return
    end
	self.slotInfo 	=  { GetContainerItemInfo( self.bagSlot, self.slotId ) } -- BLIZZ 
	if self.slotInfo[SLOTINFO_ITEM_COUNT] == nil then
		self.slotInfo[SLOTINFO_ITEM_COUNT] = 0
		return
	end

	self.item = Item(self.slotInfo[SLOTINFO_ITEM_LINK])
end

-----------------------------------------------------------------------------------------------------
--                                          CLASS METHODS
-----------------------------------------------------------------------------------------------------
-- This is called by the bag object when the lock changed event fires.
function Slot:getBagNumber()
    return self.bagSlot
end
function Slot:getItemLink()
    return self.slotInfo[SLOTINFO_ITEM_LINK]
end
function Slot:getSlotId()
    return self.slotId
end
function Slot:getItemCount()
	return self.slotInfo[SLOTINFO_ITEM_COUNT]
end
function Slot:isItemLocked()
	return self.slotInfo[SLOTINFO_IS_LOCKED]
end
function Slot:isItemReadable()
    return self.slotInfo[SLOTINFO_READABLE]
end
function Slot:isItemLootable()
    return self.slotInfo[SLOTINFO_LOOTABLE]
end
function Slot:isItemFiltered()
    return self.slotInfo[SLOTINFO_IS_FILTERED]
end
function Slot:getResult()
    return self.result
end
