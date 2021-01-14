-- Arguments
-- 1) Length of branch mine
-- 2) Torch frequency

-- Turtle Slots
-- Slot 1 = fuel
-- Slot 16 = torches

local args = {...}

local distance = 100
local torchFrequency = 9

local function loadApis()
    os.loadAPI("util.lua")
    os.loadAPI("testudo.lua")
end

local function shouldTorch()
    return testudo.getX() % torchFrequency == 1
end

local function placeTorch()
    -- TODO : verify that slot 16 has torches
    turtle.select(16)
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
            testudo.backward()
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
    loadApis()

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