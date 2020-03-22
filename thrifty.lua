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
    if numItems then
        for item=1, numItems do
            itemLink = GetLootSlotLink(item);
            _, _, lootQuantity, currencyID, _, _, isQuestItem, _, _ = GetLootSlotInfo(item);

            -- check for coin
            if Bag.isCoin(currencyID, lootQuantity) then
                LootSlot(item);
            elseif Bag.freeSpace(itemLink) then
                print("bag free!");
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
                -- print("else triggered!")
                OpenAllBags();
--                print("hre!")
                local container = Bag.bag();
                if container then
                    local bagID, slot, cheapItemPrice = Bag.findCheapest(container);
                    local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemLink);
                    -- print("price of new item: ", vendorPrice)
                    -- print("price of cheapest item: ", cheapItemPrice)
                    if cheapItemPrice < vendorPrice then
                        PickupContainerItem(bagID, slot);
                        DeleteCursorItem();
                        LootSlot(item);
                        CloseAllBags();
                        print("New Item picked up: ", itemLink);
                    end;
--                else
--                    message("nothing cheaper...")
                end;

            end;
        end;
    end;

--    CloseLoot();
    return true;
end;

--- Frame interacting with World of Warcraft API
--
local thriftFrame = CreateFrame("Frame");
thriftFrame:RegisterEvent("ADDON_LOADED");
thriftFrame:SetScript("OnEvent",function(self,event,...) self[event](self,event,...);end)

function thriftFrame:ADDON_LOADED()
    thriftFrame:UnregisterEvent("ADDON_LOADED")
    thriftFrame:SetScript("OnUpdate", function(self) Frame_OnUpdate(self) end)
end;

function Frame_OnUpdate(self)
    local numItems = GetNumLootItems();
    -- local done = nil;
    if numItems then
        done = thrift(numItems);
    end;

--    if message then print(message) end;
end;
