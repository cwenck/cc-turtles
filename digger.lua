-- Arguments: None

local args = {...}

local xSize = 0
local zSize = 0
local ySize = 0

local Direction = {
    RIGHT = "r",
    LEFT = "l"
}

local facing = Direction.LEFT

-- Load APIs
os.loadAPI("util.lua")
os.loadAPI("testudo.lua")

local function isAtBoundX()
    local x = testudo.getX()
    return x == 0 or x == (xSize - 1)
end

local function isAtBoundY()
    local y = testudo.getY()
    return y == 0 or y == (ySize - 1)
end

local function isAtBoundZ()
    local z = testudo.getZ()
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
    local evenRow = rowMod == 0

    if facing == Direction.RIGHT then
        if evenRow then
            moveOverRight() 
        else
            moveOverLeft()
        end
    elseif facing == Direction.LEFT then
        if evenRow then
            moveOverLeft()
        else
            moveOverRight() 
        end
    end
end

local function digTrippleRow()
    repeat
        testudo.digUp()
        testudo.digDown()
        testudo.forward()

        rowNum += 1
    until isAtBoundX()

    testudo.digUp()
    testudo.digDown()
end

local function digTrippleLayer()
    local rowNum = 0
    local shouldMoveOver = false

    repeat
        if shouldMoveOver then
            moveOver()
        end
        
        digTrippleTunnel()
        rowNum = rowNum +  1
        shouldMoveOver = true
    until isAtBoundZ()
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

    testudo.down()
    testudo.down()
    digTrippleLayer()
end

main()