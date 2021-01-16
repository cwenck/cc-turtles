-- Arguments
-- 1) Length of branch mine
-- 2) Torch frequency

-- Fuel and torches can go in any slot

local args = {...}

local distance = 100
local torchFrequency = 7
local buildBridge = true
local bridgeBlocks = {"minecraft:cobblestone"}

-- Load APIs
os.loadAPI("util.lua")
os.loadAPI("testudo.lua")

local function shouldTorch()
    local hasTorches = testudo.countItem("minecraft:torch")
    local correctLocationForTorch = testudo.getX() % torchFrequency == 2
    return hasTorches and correctLocationForTorch
end

local function placeTorch()
    testudo.place("minecraft:torch", testudo.StackPriority.MIN)
    turtle.select(1)
end

local function shouldBridgeUp() 
    -- Inspect will return false only for air blocks, but will still detect flowing liquids
    local foundBlock, _ = turtle.inspectUp()
    -- Detect will only detect solid blocks, so it doesn't detect liquids
    local solidBlock = turtle.detectUp()
    -- Check for flowing liquid
    return foundBlock and not solidBlock
end

local function shouldBridgeDown()
    return not turtle.detectDown()
end

-- local function tunnel()
--     local requiredMovement = distance * 2
--     testudo.refuel(requiredMovement)

--     while testudo.getX() < distance do
--         turtle.select(1)
--         testudo.forward()
--         testudo.digUp()

--         if shouldTorch() then
--             testudo.back()
--             placeTorch()
--             testudo.forward()
--         end
--     end
-- end

local function tunnel()
    testudo.up()

    while testudo.getX() < distance do
        turtle.select(1)
        testudo.forward()
        testudo.digDown()

        if shouldTorch() then
            testudo.right(2)
            placeTorch()
            testudo.right(2)
        end
    end
end

local function returnTunnel()
    testudo.right(2)
    testudo.down()

    while testudo.getX() > 0 do
        testudo.forward()

        if shouldBridgeDown() then
            testudo.placeDown(bridgeBlocks, testudo.StackPriority.MIN)
        end
    end
    turtle.select(1)
end

local function calculateRequiredFuel()
    -- Up at begining of tunnel, down at end of tunnel, so 2 extra movements
    local extraMovements = 2
    return (distance * 2) + extraMovements
end

local function main()
    if args[1] ~= nil then
        distance = tonumber(args[1])
    end

    if args[2] ~= nil then
        torchFrequency = tonumber(args[2])
    end

    print("Starting branch of length " .. distance)

    testudo.refuel(calculateRequiredFuel())
    tunnel()
    returnTunnel()
end

main()