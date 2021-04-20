local args = {...}

-- Load APIs
os.loadAPI("testudo.lua")

local function main()
    while true do
        if redstone.getInput("back") then
            testudo.forward()
        end

        os.pullEvent("redstone")
    end
end

main()