-- Arguments: None

local args = {...}

local xSize = 0
local zSize = 0
local ySize = 0

local Direction = {
    RIGHT = "r",
    LEFT = "l"
}

local LayerHight = {
    ONE = 1,
    TWO = 2,
    THREE = 3
}

local facing = Direction.RIGHT

-- Load APIs
os.loadAPI("util.lua")
os.loadAPI("testudo.lua")

local function isAtBoundX()
    local x = math.abs(testudo.getX())
    return x == 0 or x == (xSize - 1)
end

local function isAtBoundY()
    local y = math.abs(testudo.getY())
    return y == 0 or y == (ySize - 1)
end

local function isAtBoundZ()
    local z = math.abs(testudo.getZ())
    return z == 0 or z == (zSize - 1)
end

local function moveOverRight()
    testudo.right()
    testudo.forward()
    testudo.right()
end

local function moveOverLeft()
    testudo.left()
    testudo.forward()
    testudo.left()
end

local function moveOver(rowNumber)
    local rowMod = rowNumber % 2
    local oddRow = rowMod == 1

    if facing == Direction.RIGHT then
        if oddRow then
            moveOverRight() 
        else
            moveOverLeft()
        end
    elseif facing == Direction.LEFT then
        if oddRow then
            moveOverLeft()
        else
            moveOverRight() 
        end
    end
end

local function digRow(layerHight)
    for block = 1, xSize do
        if layerHight == LayerHight.THREE then
            testudo.digUp()
            testudo.digDown()
        elseif layerHight == LayerHight.TWO then
            testudo.digDown()
        end
            
        if block < xSize then
            testudo.forward()
        end
    end
end

local function digLayer(layerHight)
    if layerHight == LayerHight.THREE then testudo.down() end
    testudo.down()

    for rowNum = 1, zSize do
        digRow()

        if rowNum < zSize then
            moveOver(rowNum)
        end
    end
end

local function digLayers()
    for layerNum = 1, ySize do
        local layersRemaining = layerNum - ySize 
        local layerHight = math.max(layersRemaining, 3)
        digLayer(layerHight)
    end
end

local function main()
    if args[1] ~= nil then
        xSize = tonumber(args[1])
    end

    if args[2] ~= nil then
        zSize = tonumber(args[2])
    end

    if args[3] ~= nil then
        ySize = tonumber(args[3])
    end

    if args[4] ~= nil then
        facing = args[4]
    end

    digLayers()
end

main()