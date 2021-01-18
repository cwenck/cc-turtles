-- Arguments: None

local args = {...}

local xSize = 0
local zSize = 0
local ySize = 0

local Direction = {
    RIGHT = "r",
    LEFT = "l"
}

local direction = Direction.LEFT

-- Load APIs
os.loadAPI("util.lua")
os.loadAPI("testudo.lua")

local function isAtBoundX()
    local x = testudo.getX()
    return x == 0 or x == xSize
end

local function isAtBoundY()
    local y = testudo.getY()
    return y == 0 or y == ySize
end

local function isAtBoundZ()
    local z = testudo.getZ()
    return z == 0 or z == zSize
end

local function digTrippleLayer()
    -- while not isAtBoundX() and not isAtBoundZ() do
        repeat
            testudo.digUp()
            testudo.digDown()
            testudo.forward()
        until isAtBoundX()

        testudo.digUp()
        testudo.digDown()
    -- end
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