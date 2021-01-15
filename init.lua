local programs = {
    "branch-miner",
    "digger",
    "testudo",
    "util",
    "branch",
    "web",
    "init"
}

local function generateUrlForProgram(name, commit_hash)
    local baseUrl = "https://raw.githubusercontent.com/cwenck/cc-turtles/master"
    return baseUrl .. "/" .. commit_hash .. "/" .. name .. ".lua"
end

-- Gets the commit hash of the HEAD reference for the specified branch
local function getLatestCommitHash(branch)
    local body = web.get("https://github.com/cwenck/cc-turtles.git/info/refs?service=git-upload-pack")
    local _, _, hash = string.find(body, "003f(%x+) refs/heads/" .. branch)
    print("Hash: '" .. hash .. "'")
    return hash
end

local function downloadProgram(name, commit_hash)
    print("Downloading " .. name .. " ...")
    
    local fullName = name .. ".lua"
    local url = generateUrlForProgram(name, commit_hash)
    
    -- Delete tmp file if it exists
    local tmpFileName = "tmp-download"
    if fs.exists(tmpFileName) then
        fs.delete(tmpFileName)
    end
    
    -- Download the program
    local success = web.download(url, tmpFileName)
    print("Success: " .. tostring(success))

    -- Delete the program if it already exists
    if fs.exists(fullName) then
        fs.delete(fullName)
    end

    -- Move the downloaded file to the actual file name
    fs.move(tmpFileName, fullName)

    print("Finished downloading " .. name)
end

function main()
    os.loadAPI("web.lua")

    commit_hash = getLatestCommitHash("master")
    for _, name in ipairs(programs) do
        downloadProgram(name, commit_hash)
    end
end

main()