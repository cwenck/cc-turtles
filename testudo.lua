os.loadAPI("util.lua")
-----------------------------------------

RelativeDirection = {
    FORWARD = 0,
    RIGHT = 1,
    BACKWARD = 2,
    LEFT = 3,
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
        if not turtle.refuel() then
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
function forward(force)
    force = util.getOrDefault(force, true)

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

-- Move up.
function up(force)
    force = util.getOrDefault(force, true)

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

-- Move down.
function down(force)
    force = util.getOrDefault(force, true)

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

-- Turn left.
function left()
    turtle.turnLeft()

    -- Update the facing
    facing = (facing - 1) % 4
end

-- Turn right.
function right()
    turtle.turnRight()

    -- Update the facing
    facing = (facing + 1) % 4
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