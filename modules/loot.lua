--
-- Created by IntelliJ IDEA.
-- User: alexa
-- Date: 21/11/2019
-- Time: 15:47
-- To change this template use File | Settings | File Templates.
--

local A, Bag, Loot=...;

function Loot.isCoin(currencyID, lootQuantity)
    return currencyID == nil and lootQuantity == 0;
end