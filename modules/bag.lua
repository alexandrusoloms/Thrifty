--
-- Created by IntelliJ IDEA.
-- User: alexa
-- Date: 20/11/2019
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local A, Bag=...;

function Bag.isCoin(currencyID, lootQuantity)
    return currencyID == nil and lootQuantity == 0;
end

function Bag.bag()
    local container = {};
    local itemCounter = 0;
    for bagIndex=0,4 do
        bagName = GetBagName(bagIndex);
        local numberOfSlots = GetContainerNumSlots(bagIndex);
        for bagSlot=0, numberOfSlots do
            if bagSlot == 0 then container[bagIndex + 1] = {} end;
            local _, itemCount, _, _, _, _, link, _, _, _ = GetContainerItemInfo(bagIndex, bagSlot);
            if link then
                local _, _, quality, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(link);
                --- only looks at trash items (quality of 0)... TODO: expand this in the future.
                if quality == 0 then
                    container[bagIndex + 1][bagSlot + 1] = itemCount * itemSellPrice;
                    itemCounter = itemCounter + 1;
                end
            else
                container[bagIndex + 1][bagSlot + 1] = nil; -- meaning this is empty!
            end;
        end
    end
    if itemCounter > 0 then
       return container;
    else
        return false;
    end;
end

function Bag.findCheapest(container)
    local min = 1e300;
    local minBag;
    local minIndex;
    for i=1,5 do
        for j=1,19 do
            if container[i][j] and container[i][j] > 0 then
                if container[i][j] < min then
                    min = container[i][j];
                    minBag = i;
                    minIndex = j;
                end
            end;
        end
    end
    local _, _, _, _, _, _, link, _, _, _ = GetContainerItemInfo(minBag-1, minIndex-1);
--    print("Cheapest Item: ", link);
    return minBag-1, minIndex-1, min;
end

function Bag.freeSpace(itemLink)

    local totalFreeSpace = 0;

    local itemType, itemSubType, _, _, _, _, classID, subclassID = select(5, GetItemInfo(itemLink))  -- changed from 6 to 5  AMS
    -- print(itemType, "<< item type")
    -- print(classID, "<< item class ID")
    -- print(subclassID, "<< item sub class ID")

    for bag=0, 4 do
        local free, type = GetContainerNumFreeSlots(bag);
        -- print(type, "<<<<<<<< type!!")
        if type == 0 then
            totalFreeSpace = totalFreeSpace + free;
        elseif type == 6 then
        --    print(itemType, itemSubTyped, classID, subclassID);
            if classID == 7 and subclassID == 0 then
--                print("Item is plant! ")
                totalFreeSpace = totalFreeSpace + free;
            else
                totalFreeSpace = totalFreeSpace + 0;
                end;
        end;

    end
    -- print(totalFreeSpace, "---- free space calculated")
    if totalFreeSpace == 0 then return false;
    else return true end;
end

--- checks if the item to be picked up can be stacked...
-- @param itemLink
-- @param itemQuantity
--
function Bag.canStack(itemLink, itemQuantity)

    local booleanContainer = {};
    local counter = 1;
    for bagIndex=0,4 do
        local numberOfSlots = GetContainerNumSlots(bagIndex);
        for bagSlot=0, numberOfSlots do
            local _, itemCount, _, _, _, _, link, _, _, _ = GetContainerItemInfo(bagIndex, bagSlot);
            if link then
                local name, _, quality, _, _, _, _, itemStackCount, _, _, itemSellPrice = GetItemInfo(link);
                if itemLink == link then
                    if itemCount + itemQuantity <= itemStackCount then
                        booleanContainer[counter] = true;
                        counter = counter + 1;
                    else
                        booleanContainer[counter] = false;
                        counter = counter + 1;
                        end;
                end;
            end;
        end;
    end;

    for i=1, counter do
        if booleanContainer[i] == true then
            return true;
        end
    end
    return false;
end

--return Bag;
