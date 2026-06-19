

-- Decision.lua
-- Fixed reagent check + cleaner structure

ChaChing = ChaChing or {}
ChaChing.Decision = ChaChing.Decision or {}

local core = ChaChing.Core
local Decision = ChaChing.Decision
local decisionCache = {}

function Decision:GetSellDecision(bag, slot)
    local key = bag .. "-" .. slot .. "-" .. (UnitLevel("player") or 0)
    if decisionCache[key] then
        return decisionCache[key].sell, decisionCache[key].reason
    end

    local link = C_Container.GetContainerItemLink(bag, slot)
    if not link then
        decisionCache[key] = {sell = false, reason = "no item"}
        return false, "no item"
    end

    local itemID, _, _, equipLoc, _, classID, subclassID = C_Item.GetItemInfoInstant(link)
    local name, _, quality, _, minLevel, _, _, _, _, _, sellPrice, _, _, _, _, _, isCraftingReagent = C_Item.GetItemInfo(link)

    if not name or (sellPrice or 0) == 0 then
        decisionCache[key] = {sell = false, reason = "no sell price"}
        return false, "no sell price"
    end

    -- STEP 1: Grey items — always sell
    if quality == 0 then
        decisionCache[key] = {sell = true, reason = "grey trash"}
        return true, "grey trash"
    end

    -- STEP 2: Soulbound check
    local isSoulbound = ChaChing:IsSoulbound(bag, slot) or
                        ChaChing:TooltipContains(link, "Soulbound") or
                        ChaChing:TooltipContains(link, "Binds when picked up")

    -- STEP 3: White items
    if quality == 1 then
        local sell, reason = Decision:_WhiteItemRules(itemID, classID, subclassID, isCraftingReagent, link)
        decisionCache[key] = {sell = sell, reason = reason}
        return sell, reason
    end

    if not isSoulbound then
        decisionCache[key] = {sell = false, reason = "not soulbound"}
        return false, "not soulbound"
    end

    -- STEP 4: Enchanter protection
    if quality >= 2 and quality <= 4 and IsSpellKnown(7411) then
        decisionCache[key] = {sell = false, reason = "enchanter protection"}
        return false, "enchanter protection"
    end

    -- STEP 5: Recipes
    if classID == 9 then
        local sell, reason = Decision:_RecipeRules(link)
        decisionCache[key] = {sell = sell, reason = reason}
        return sell, reason
    end

    -- STEP 6+: Soulbound unusable gear
    if isSoulbound or classID == 4 or classID == 2 then
        if not Decision:CanPlayerUseItem(link, minLevel, equipLoc, classID, subclassID) then
            decisionCache[key] = {sell = true, reason = "cannot use"}
            return true, "cannot use"
        end
    end

    decisionCache[key] = {sell = false, reason = "safe keep"}
    return false, "safe keep"
end

-- White Item Rules (now passes isCraftingReagent)
function Decision:_WhiteItemRules(itemID, classID, subclassID, isCraftingReagent, link)
    -- Crafting reagent (from GetItemInfo)
    if isCraftingReagent then
        return false, "crafting reagent"
    end

    -- Cloth
    if classID == 4 and subclassID == 1 then
        return false, "cloth"
    end

    -- Stat food
    if ChaChing:TooltipContainsAny(link, {
        "Well Fed", "Stamina", "Strength", "Agility", "Intellect", "Spirit",
        "Versatility", "Haste", "Mastery", "Critical Strike"
    }) then
        return false, "stat food"
    end

    return true, "white junk"
end

function Decision:_RecipeRules(link)
    if ChaChing:TooltipContains(link, "Already known") or
       ChaChing:TooltipContains(link, "You already know") then
        return true, "known recipe"
    end
    return false, "useful recipe"
end

function Decision:CanPlayerUseItem(link, minLevel, equipLoc, classID, subclassID)
    if minLevel and minLevel > UnitLevel("player") then
        return false
    end
    return C_Item.IsEquippableItem(link)
end

function Decision:ClearCache()
    wipe(decisionCache)
end

function ChaChing:TestEntireBag(verbose)
    print("|cffffd700ChaChing Test Scan Started|r")

    local sellCount, keepCount, totalValue = 0, 0, 0

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link then
                local sell, reason = ChaChing.Decision:GetSellDecision(bag, slot)
                local _, _, _, _, _, _, _, _, _, _, sellPrice = C_Item.GetItemInfo(link)

                if sell then
                    sellCount = sellCount + 1
                    totalValue = totalValue + (sellPrice or 0)
                    if verbose then
                        dbg.print(string.format("SELL |cffa0a0a0[%s]|r → %s", link, reason))
                    end
                else
                    keepCount = keepCount + 1
                    if verbose then
                        dbg.print(string.format("KEEP |cffa0a0a0[%s]|r → %s", link, reason))
                    end
                end
            end
        end
    end

    print(string.format("|cffffd700ChaChing Test Results:|r %d to SELL (~%s) | %d to KEEP",
    sellCount, GetCoinText(totalValue), keepCount))
end

if core:debuggingIsEnabled() then
    local fileName = "Decision.lua"
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s loaded", fileName), 0, 1, 0)
end
