args = {...}

programs = {
    "init",
    "branch-miner"
}

function main()
    for name in pairs(programs) do
        downloadProgram(name)
    end
end

function generateUrlForProgram(name)
    local baseUrl = "https://raw.githubusercontent.com/cwenck/cc-turtles/master/"
    return baseUrl .. name .. ".lua"
end

function downloadProgram(name)
    local url = generateUrlForProgram(name)

    -- Delete the program if it already exists
    if fs.exists(name) then
        fs.delete(name)
    end

    -- Download the program
    local fullName = name .. ".lua"
    shell.run("wget", url, fullName)
end