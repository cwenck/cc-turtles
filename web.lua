if not http then
    printError("Requires the HTTP API")
    printError("Set http_enable to true in ComputerCraft.cfg")
    return
end
 
local function get(url)
    local ok, err = http.checkURL(url)
    if not ok then
        if err then
            printError(err)
        end
        return nil
    end

    local headers = {
        ["Cache-Control"] = "no-store"
    }

    local response = http.get(url, headers)
    if not response then
        return nil
    end

    local responseBody = response.readAll()
    response.close()
    return responseBody
end
 
function download(shell, url, name)
    local path = shell.resolve(name)
    local response = get(url)
    if response then
        local file = fs.open(path, "wb")
        file.write(response)
        file.close()
    end
end