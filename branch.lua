-- Arguments
-- 1) Length of branch mine
-- 2) Torch frequency

-- Turtle Slots
-- Slot 1 = fuel
-- Slot 16 = torches

local args = {...}

local distance = 100
local torchFrequency = 7

-- Load APIs
os.loadAPI("util.lua")
os.loadAPI("testudo.lua")

local function selectTorch() {
    testudo.selectSlotWithMinItem("minecraft:torch")
}

local function shouldTorch()
    local hasTorches = testudo.itemCount("minecraft:torch")
    local correctLocation = testudo.getX() % torchFrequency == 2
    return hasTorches and correctLocation
end

local function placeTorch()
    testudo.selectSlotWithMinItem("minecraft:torch")
    turtle.placeUp()
    turtle.select(1)
end

local function tunnel()
    local requiredMovement = distance * 2
    testudo.refuel(requiredMovement)

    while testudo.getX() < distance do
        turtle.select(1)
        testudo.forward()
        testudo.digUp()

        if shouldTorch() then
            testudo.back()
            placeTorch()
            testudo.forward()
        end
    end
end

local function returnTunnel()
    while testudo.getX() > 0 do
        testudo.forward()
    end
end

local function main()
    if args[1] ~= nil then
        distance = tonumber(args[1])
    end

    if args[2] ~= nil then
        torchFrequency = tonumber(args[2])
    end

    print("Starting branch of length " .. distance)

    tunnel()
    testudo.right()
    testudo.right()
    returnTunnel()
end

main()