os.loadAPI("util.lua")
-----------------------------------------

----------------------------
-- MOVEMENT & POSITIONING --
----------------------------

RelativeDirection = {
    FORWARD = 0,
    RIGHT = 1,
    BACKWARD = 2,
    LEFT = 3,
}

Side = {
    FRONT = 0,
    LEFT = 1,
    BACK = 2,
    RIGHT = 3,
    UP = 4,
    DOWN = 5
}

-----------------------------------------

local debugEnabled = false

-- The fuel values given by different fuel items
local itemFuelAmounts = {}
itemFuelAmounts["minecraft:coal"] = 80

-- This is the offset from the turtle starting position in the forward direction
local xOffset = 0

--  This is the offset from the turtle starting position in the up direction
local yOffset = 0

-- This is the offset from the turtle starting position in the right direction
local zOffset = 0

local facing = RelativeDirection.FORWARD

-----------------------------------------

local function debug(msg)
    if debugEnabled then
        print(msg)
    end
end

-- Wait for the enter key to be pressed.
local function waitForEnterKeyPress()
    while true do
        local event, peram = os.pullEvent("key")
        if event == "key" and peram == 28 then
            break
        end
    end
end

local function collectDroppedItems()
    turtle.suckUp()
    turtle.suck()
    turtle.suckDown()
end

local function hasAnyFuel()
    return turtle.getFuelLevel() > 0
end

-- Check if the turtle has enough fuel to perform the specified number of movements.
local function hasFuel(threshold)
    return turtle.getFuelLevel() >= threshold
end

-- Try to refuel up to the threshold using the items in a given slot. Returns whether the operation was succcessful.
local function tryRefuelFromSlot(slot, threshold)
    -- Save the originally selected slot
    local originalSlot = turtle.getSelectedSlot()
    turtle.select(slot)

    while not hasFuel(threshold) do
        if not turtle.refuel(1) then
            turtle.select(originalSlot)
            return false
        end
    end

    turtle.select(originalSlot)
    return true
end

-- Refuel the turtle up to a particual threshold.
function refuel(threshold)
    -- Save the originally selected slot
    local originalSlot = turtle.getSelectedSlot()

    while not hasFuel(threshold) do
        for slot = 1,16 do
            if tryRefuelFromSlot(slot, threshold) then
                break
            end
        end

        if not hasFuel(threshold) then
            -- No fuel in turtle
            print("In need of fuel.")
            print("Press enter to continue...")
            waitForEnterKeyPress()
        end
    end

    -- Restore the originally selected slot
    turtle.select(originalSlot)
end

function refuelMinimum()
    refuel(1)
end

function dig()
    if turtle.detect() then
        turtle.dig()
    end

    collectDroppedItems()
end

-- Dig up if there is a block to break.
function digUp()
    -- Detect and dig up in a loop to handle falling blocks
    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.5)
    end

    collectDroppedItems()
end

-- Dig down if there is a block to break.
function digDown()
    if turtle.detectDown() then
        turtle.digDown()
    end

    collectDroppedItems()
end

-- Move forward.
function forward(count, force)
    count = util.getOrDefault(count, 1)
    force = util.getOrDefault(force, true)

    for _ = 1, count do
        while not hasAnyFuel() do
            refuelMinimum()
        end

        repeat
            if force then
                dig()
            end
        until (turtle.forward())

        if facing == RelativeDirection.FORWARD then
            xOffset = xOffset + 1
        elseif facing == RelativeDirection.BACKWARD then
            xOffset = xOffset - 1
        elseif facing == RelativeDirection.RIGHT then
            zOffset = zOffset + 1
        elseif facing == RelativeDirection.LEFT then
            zOffset = zOffset - 1
        else
            error("Unknown facing " .. facing)
        end
    end
end

-- Move backward.
function back(count)
    count = util.getOrDefault(count, 1)

    for _ = 1, count do
        while not hasAnyFuel() do
            refuelMinimum()
        end

        repeat until (turtle.back())

        if facing == RelativeDirection.FORWARD then
            xOffset = xOffset - 1
        elseif facing == RelativeDirection.BACKWARD then
            xOffset = xOffset + 1
        elseif facing == RelativeDirection.RIGHT then
            zOffset = zOffset - 1
        elseif facing == RelativeDirection.LEFT then
            zOffset = zOffset + 1
        else
            error("Unknown facing " .. facing)
        end
    end
end

-- Move up.
function up(count, force)
    count = util.getOrDefault(count, 1)
    force = util.getOrDefault(force, true)

    for _ = 1, count do
        while not hasAnyFuel() do
            refuelMinimum()
        end

        repeat
            if force then
                digUp()
            end
        until (turtle.up())

        yOffset = yOffset + 1
    end
end

-- Move down.
function down(count, force)
    count = util.getOrDefault(count, 1)
    force = util.getOrDefault(force, true)

    for _ = 1, count do
        while not hasAnyFuel() do
            refuelMinimum()
        end

        repeat
            if force then
                digDown()
            end
        until (turtle.down())

        yOffset = yOffset - 1
    end
end

-- Turn left.
function left(count)
    count = util.getOrDefault(count, 1)

    for _ = 1, count do
        turtle.turnLeft()

        -- Update the facing
        facing = (facing - 1) % 4
    end
end

-- Turn right.
function right(count)
    count = util.getOrDefault(count, 1)

    for _ = 1, count do
        turtle.turnRight()

        -- Update the facing
        facing = (facing + 1) % 4
    end
end

function resetPosition()
    xOffset = 0
    yOffset = 0
    zOffset = 0
end

function resetFacing()
    facing = RelativeDirection.FORWARD
end

function getX()
    return xOffset
end

function getY()
    return yOffset
end

function getZ()
    return zOffset
end

function getFacing()
    return facing
end

--------------------------
-- INVENTORY MANAGEMENT --
--------------------------

StackType = {
    EMPTY = "EMPTY",
    PARTIAL = "PARTIAL",
    FULL = "FULL"
}

local function isItemMatch(slotInfo, items)
    items = util.toTable(items)

    if slotInfo == nil then
        return false
    end

    for _, item in pairs(items) do
        if slotInfo.name == item then
            return true
        end
    end

    return false
end

function inspectInventoryContents()
    local inventory = {}

    for i = 1,16 do
        inventory[i] = {
            slot = i,
            details = turtle.getItemDetail(i),
        }

        if inventory[i].details ~= nil then
            local space = turtle.getItemSpace(i)
            local count = turtle.getItemCount(i)

            inventory[i].details.space = space
            inventory[i].details.stack = space + count
        end
    end

    return inventory
end

-- Inspects the contents of a single turtle inventory slot.
--   [slot]: the slot to inspect; defaults to the currently selected slot
function inspectSlot(slot)
    slot = util.getOrDefault(slot, turtle.getSelectedSlot())
    
    local result = {}
    local details = turtle.getItemDetail(slot)

    result.slot = slot
    result.count = turtle.getItemCount(slot)
    result.stackType = StackType.EMPTY

    if details ~= nil then
        result.space = turtle.getItemSpace(slot)
        result.maxCount = result.space + result.count
        result.name = details.name
        result.stackType = util.ternary(result.space == 0, StackType.FULL, StackType.PARTIAL)
    end

    function result.isEmpty()
        return result.stackType == StackType.EMPTY
    end

    function result.isPartialStack()
        return result.stackType == StackType.PARTIAL
    end

    function result.isFullStack()
        return result.stackType == StackType.FULL
    end

    return result
end

-- Inspects the contents of a range of turtle inventory slots.
--   [staringSlot]: the slot from which to start inspecting (inclusive); defaults to 1
--   [endingSlot]: the slot from which to end inspecting (inclusive); defaults to 16
function inspectSlots(startingSlot, endingSlot)
    startingSlot = util.getOrDefault(startingSlot, 1)
    endingSlot = util.getOrDefault(endingSlot, 16)

    local contents = {}
    for slot = startingSlot, endingSlot do
        contents[slot] = inspectSlot(slot)
    end

    return contents
end

-- Counts the sum of each type of item in the turtle's inventory
function countItems()
    local inventory = inspectSlots()
    local itemCounts = {}

    for _, slotInfo in pairs(inventory) do
        if not slotInfo.isEmpty() then
            local name = slotInfo.name
            itemCounts[name] = slotInfo.count + util.getOrDefault(itemCounts[name], 0)
        end
    end

    return itemCounts
end

-- Counts the number of a specific item in the turtle's inventory
function countItem(item)
    return util.getOrDefault(countItems()[item], 0)
end

function findSlotWithMinItem(items)
    local inventory = inspectSlots()

    local minCount = nil
    local bestSlot = nil

    for _, slotInfo in pairs(inventory) do
        if isItemMatch(slotInfo, items) then
            if minCount == nil or slotInfo.count < minCount then
                minCount = slotInfo.count
                bestSlot = slotInfo.slot
            end
        end
    end

    return bestSlot
end

function findSlotWithMaxItem(items)
    local inventory = inspectSlots()

    local maxCount = nil
    local bestSlot = nil

    for _, slotInfo in pairs(inventory) do
        if isItemMatch(slotInfo, items) then
            if maxCount == nil or slotInfo.count > maxCount then
                maxCount = slotInfo.count
                bestSlot = slotInfo.slot
            end
        end
    end

    return bestSlot
end

function selectSlotWithMinItem(item)
    local slot = findSlotWithMinItem(item)

    if slot ~= nil then
        turtle.select(slot)
    end
end

function selectSlotWithMaxItem(item)
    local slot = findSlotWithMaxItem(item)

    if slot ~= nil then
        turtle.select(slot)
    end
end