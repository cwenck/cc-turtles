-- Arguments: None

local args = {...}

-- Load APIs
os.loadAPI("testudo.lua")

local function ascend() 
    testudo.forward()
    while turtle.detectUp() do
        testudo.dig()
        testudo.up()
    end
    testudo.dig()
end

local function moveOver()
    testudo.right()
    testudo.forward()
    testudo.left()
end

local function descend()
    while testudo.getY() > 0 do
        testudo.dig()
        testudo.down()
    end
    testudo.dig()
    testudo.collectDroppedItems()
    testudo.back()
end

local function main()
    ascend()
    moveOver()
    descend()
end

main()