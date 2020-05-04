local programs = {
    "init",
    "branch-miner",
    "digger",
    "position"
}

function main()
    for _, name in ipairs(programs) do
        downloadProgram(name)
    end
end

function generateUrlForProgram(name)
    local baseUrl = "https://raw.githubusercontent.com/cwenck/cc-turtles/master/"
    return baseUrl .. name .. ".lua"
end

function downloadProgram(name)
    print("Downloading " .. name .. " ...")
    
    local fullName = name .. ".lua"
    local url = generateUrlForProgram(name)

    -- Delete the program if it already exists
    if fs.exists(fullName) then
        fs.delete(fullName)
    end

    -- Download the program

    shell.run("wget", url, fullName)

    print("Finished downloading " .. name)
end

main()