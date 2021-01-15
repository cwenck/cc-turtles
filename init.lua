local programs = {
    "init",
    "branch-miner",
    "digger",
    "testudo",
    "util",
    "branch",
    "web"
}

function main()
    os.loadAPI("web.lua")

    commit_hash = getLatestHeadRef("master")
    for _, name in ipairs(programs) do
        downloadProgram(name, commit_hash)
    end
end

local function generateUrlForProgram(name, commit_hash)
    local baseUrl = "https://raw.githubusercontent.com/cwenck/cc-turtles/master/"
    return baseUrl .. "/" .. commit_hash .. "/" .. name .. ".lua"
end

-- Gets the commit hash of the HEAD reference for the specified branch
local function getLatestCommitHash(branch) {
    body = web.get("https://github.com/cwenck/cc-turtles.git/info/refs?service=git-upload-pack")
    print(body)
    _, _, hash = string.find(body, "003f(%x+) refs/heads/" .. branch)
    print("Hash:" .. hash)
    return hash
}

function downloadProgram(name, commit_hash)
    print("Downloading " .. name .. " ...")
    
    local fullName = name .. ".lua"
    local url = generateUrlForProgram(name, commit_hash)
    print("URL: " .. url)

    -- Delete the program if it already exists
    if fs.exists(fullName) then
        fs.delete(fullName)
    end

    -- Download the program
    web.download(shell, url, fullName)

    print("Finished downloading " .. name)
end

main()