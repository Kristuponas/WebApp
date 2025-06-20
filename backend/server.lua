local socket = require("socket")
local json = require("dkjson")

local users = {
    { username = "admin", password = "1234" }
}

local function send_json(client, obj, status)
    local body = json.encode(obj)
    client:send("HTTP/1.1 " .. (status or "200") .. " OK\r\n" ..
        "Access-Control-Allow-Origin: *\r\n" ..
        "Access-Control-Allow-Methods: POST, GET, OPTIONS\r\n" ..
        "Access-Control-Allow-Headers: Content-Type\r\n" ..
        "Content-Type: application/json\r\n" ..
        "Content-Length: " .. #body .. "\r\n\r\n" ..
        body)
end

local server = socket.bind("*", 8080)
print("Lua API running on port 8080")

while true do
    -- Accepts incoming requests
    local client = server:accept()
    client:settimeout(1)

    -- Reads first line of the HTTP request line
    local request = client:receive("*l")
    print("Request:", request)

    --[[
        Breaks this type of request:
        request = "POST /login HTTP/1.1"

        Into:
        method = "POST"
        path = "/login"

        ^      -> Match from the start of the string
        (%w+)  -> Capture one or more word characters
        %s     -> Match one or more spaces
        (/%S*) -> Capture a / followed by zero or more non-space characters
    ]]
    local method, path = request:match("^(%w+)%s+(/%S*)")
    print("Method:", method, "Path:", path)

    if method == "OPTIONS" then
        client:send("HTTP/1.1 204 No Content\r\n" ..
            "Access-Control-Allow-Origin: *\r\n" ..
            "Access-Control-Allow-Methods: POST, GET, OPTIONS\r\n" ..
            "Access-Control-Allow-Headers: Content-Type\r\n" ..
            "Content-Length: 0\r\n\r\n")
    elseif method == "POST" and path == "/login" then
        -- First read headers to get Content-Length
        local content_length = 0
        local headers = {}
        while true do
            local line = client:receive()
            if line == "" then break end

            --[[
                Breaks this type of match:
                line = "Content-Length: 45"

                Into:
                key = "Content-Length"
                value = "45"

                ^        -> Match from the start of the string
                ([%w-]+) -> Match and capture a string of word characters (in this case: Content-Length)
                :        -> Match the colon literally
                %s*      -> Match zero or more spaces
                (.+)     -> Capture everything else (the actual value)
                $        -> End of line
            ]]
            local key, value = line:match("^([%w-]+):%s*(.+)$")
            if key and key:lower() == "content-length" then
                content_length = tonumber(value)
            end
            headers[key] = value
        end

        -- Reads JSON body ({"username":"admin", "password":"1234"})
        local body = content_length > 0 and client:receive(content_length) or ""
        -- Decodes JSON input to Lua table
        local ok, data = pcall(json.decode, body)

        if not ok then
            send_json(client, { success = false, message = "Invalid JSON" }, 400)
        else
            local found = false
            for _, user in ipairs(users) do
                if user.username == data.username and user.password == data.password then
                    found = true
                    break
                end
            end
            send_json(client, { success = found, message = found and "Login successful" or "Invalid credentials" })
        end
    end

    client:close()
end
