if not http then
    printError("Requires the HTTP API")
    printError("Set http_enable to true in ComputerCraft.cfg")
    return
end
 
function get(url)
    local ok, err = http.checkURL(url)
    if not ok then
        if err then
            printError(err)
        end
        return nil
    end

    local response = http.get(url)
    if not response then
        return nil
    end

    local statusCode = response.getResponseCode()
    print("Status: " .. tostring(statusCode))

    local responseBody = response.readAll()
    response.close()
    return responseBody
end

function download(url, path)
    local response = get(url)
    if response then
        local file = fs.open(path, "wb")
        file.write(response)
        file.close()
        return true
    end
    return false
end