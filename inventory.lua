-- os.loadAPI("util.lua")
-----------------------------------------

function pushItems(fromInventory, intoInventory, fromSlot, toSlot, limit)
    fromInventory.pushItems(peripheral.getName(intoInventory), fromSlot, limit, toSlot)
end

function pushSingleItem(fromInventory, intoInventory, fromSlot, toSlot)
    fromInventory.pushItems(peripheral.getName(intoInventory), fromSlot, 1, toSlot)
end

function pullItems(fromInventory, intoInventory, fromSlot, toSlot, limit)
    fromInventory.pullItems(peripheral.getName(intoInventory), fromSlot, limit, toSlot)
end

function pullSingleItem(fromInventory, intoInventory, fromSlot, toSlot)
    fromInventory.pullItems(peripheral.getName(intoInventory), fromSlot, 1, toSlot)
end

function pushAll(fromInventory, intoInventory)
    itemContents = fromInventory.list()
    for slot in pairs(itemContents) do
        pushItems(fromInventory, intoInventory, slot)
    end
end

function pullAll(fromInventory, intoInventory)
    itemContents = fromInventory.list()
    for slot in pairs(itemContents) do
        pullItems(fromInventory, intoInventory, slot)
    end
end