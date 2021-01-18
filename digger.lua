-- Arguments: None

local args = {...}

local xSize = 0
local zSize = 0
local ySize = 0

local Direction = {
    RIGHT = "r"
    LEFT = "l"
}
local direction = Direction.LEFT

-- Load APIs
os.loadAPI("util.lua")
os.loadAPI("testudo.lua")

local function isAtBoundX()
    
end

local function isAtBoundY()
    
end

local function isAtBoundZ()

end

local function digTrippleLayer()
    -- while not isAtBoundX() and not isAtBoundZ() do
        while not isAtBoundX() do
            testudo.digUp()
            testudo.digDown()
            testudo.forward()
        end

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

    digTrippleLayer()
end

main()