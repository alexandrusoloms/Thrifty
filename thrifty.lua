--
-- Created by IntelliJ IDEA.
-- User: alexa
-- Date: 20/11/2019
-- Time: 23:36
-- To change this template use File | Settings | File Templates.
--
local A, Bag = ...;

--- `thrift` is triggered when a looting event occurs.
--
local function thrift(numItems)

    local itemLink;
    local lootQuantity;
    local currencyID;
    local isQuestItem;
    local _;
    
    for item=1, numItems do
        itemLink = GetLootSlotLink(item);
        _, _, lootQuantity, currencyID, _, _, isQuestItem, _, _ = GetLootSlotInfo(item);

        if Bag.isCoin(currencyID, lootQuantity) then
            LootSlot(item);
        elseif Bag.freeSpace(itemLink) then
            LootSlot(item);
        elseif Bag.canStack(itemLink, lootQuantity) then
            LootSlot(item);
        elseif isQuestItem then
            local container = Bag.bag();
            local bagID, slot, cheapItemPrice = Bag.findCheapest(container);
            OpenAllBags();
            PickupContainerItem(bagID, slot);
            DeleteCursorItem();
            LootSlot(item);
            CloseAllBags();
        else
            OpenAllBags();
            local container = Bag.bag();
            if container then
                local bagID, slot, cheapItemPrice = Bag.findCheapest(container);
                local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemLink);
                if cheapItemPrice < vendorPrice then
                    PickupContainerItem(bagID, slot);
                    DeleteCursorItem();
                    LootSlot(item);
                    CloseAllBags();
                    print("New Item picked up: ", itemLink);
                end;
            end;

        end;
    end;
end;


--- Frame interacting with World of Warcraft API
--
local thriftFrame = CreateFrame("Frame");
thriftFrame:RegisterEvent("LOOT_OPENED");
thriftFrame:SetScript("OnEvent", function(self, event, ...)
    local numItems = GetNumLootItems();
    if numItems then
        thrift(numItems)
    end;
end)