local socket = require("socket")
local json = require("dkjson")
local sessions = {}

local USERS_FILE = "users.json"

-- Load users from file
local function load_users()
    local file = io.open(USERS_FILE, "r")
    if not file then return {} end
    local content = file:read("*a")
    file:close()
    return json.decode(content) or {}
end

-- Save users to file
local function save_users(users)
    local file = io.open(USERS_FILE, "w")
    file:write(json.encode(users, { indent = true }))
    file:close()
end

-- Read headers and body
local function read_request(client)
    local headers = {}
    local content_length = 0
    local line
    repeat
        line = client:receive()
        if line and line ~= "" then
            --[[
                Breaks this type of match:
                line = "Content-Length: 45"

                Into:
                key = "Content-Length"
                value = "45"

                ^        -> Match from the start of the string
                ([%w-]+) -> Captures header name;
                            %w matches any character (letters & digits)
                            - allows hyphens (In this case: Content-Type)
                            + mean one or more of those
                :        -> Match the colon literally
                %s*      -> Match zero or more spaces
                (.+)     -> Capture everything else (the actual value)
                $        -> End of line

            ]]
            local key, value = line:match("^([%w-]+):%s*(.+)$")
            if key and value then
                headers[key:lower()] = value
                if key:lower() == "content-length" then
                    content_length = tonumber(value)
                end
            end
        end
    until line == ""
    local body = content_length > 0 and client:receive(content_length) or ""
    return headers, body
end

-- Send JSON response
local function send_json(client, obj, status)
    local body = json.encode(obj)
    client:send("HTTP/1.1 " .. (status or "200 OK") .. "\r\n" ..
        "Access-Control-Allow-Origin: *\r\n" ..
        "Access-Control-Allow-Methods: POST, GET, OPTIONS\r\n" ..
        "Access-Control-Allow-Headers: Content-Type, Authorization\r\n" ..
        "Content-Type: application/json\r\n" ..
        "Content-Length: " .. #body .. "\r\n\r\n" ..
        body)
end

-- Start server
local server = socket.bind("*", 8080)
print("Lua API running on port 8080")

while true do
    -- Accepts incoming requests
    local client = server:accept()
    client:settimeout(1)

    local function handle_client()
        -- Reads first line of the HTTP request line
        local request_line = client:receive("*l")
        if not request_line then
            return
        end

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
        print("Request:", request_line)
        local method, path = request_line:match("^(%w+)%s+(/%S*)")

        if method == "OPTIONS" then
            client:send("HTTP/1.1 204 No Content\r\n" ..
                "Access-Control-Allow-Origin: *\r\n" ..
                "Access-Control-Allow-Methods: POST, GET, OPTIONS\r\n" ..
                "Access-Control-Allow-Headers: Content-Type, Authorization\r\n" ..
                "Content-Length: 0\r\n\r\n")
            return
        end

        if method == "POST" and path == "/signin" then
            local _, body = read_request(client)
            local data = json.decode(body)
            local users = load_users()
            local found = false

            for _, user in ipairs(users) do
                if user.username == data.username and user.password == data.password then
                    found = true
                    break
                end
            end

            if found then
                local token = tostring(os.time()) .. tostring(math.random(1000, 9999))
                sessions[token] = data.username

                send_json(client, { success = true, message = "Login successful", token = token })
            else
                send_json(client, { success = false, message = "Invalid credentials" }, "401 Unauthorized")
            end
            return
        end

        if method == "POST" and path == "/signup" then
            local _, body = read_request(client)
            local data = json.decode(body)
            local users = load_users()

            for _, user in ipairs(users) do
                if user.username == data.username then
                    send_json(client, { success = false, message = "User already exists" }, "400 Bad Request")
                    return
                end
                if user.email == data.email then
                    send_json(client, { success = false, message = "Email already in use" }, "400 Bad Request")
                    return
                end
            end

            table.insert(users, { username = data.username, email = data.email, password = data.password, })
            save_users(users)

            send_json(client, { success = true, message = "Signup successful" })
            return
        end

        if method == "GET" and path == "/profile" then
            local headers, _ = read_request(client)
            local token = headers["authorization"]

            if token and sessions[token] then
                local username = sessions[token]
                local users = load_users()

                for _, user in ipairs(users) do
                    if user.username == username then
                        send_json(client, {
                            success = true,
                            username = user.username,
                            email = user.email,
                            password = user.password -- you may want to hide this later
                        })
                        return
                    end
                end

                send_json(client, { success = false, message = "User not found" }, "404 Not Found")
            else
                send_json(client, { success = false, message = "Unauthorized" }, "401 Unauthorized")
            end
            return
        end

        if method == "GET" and path == "/changePassword" then
            local headers, _ = read_request(client)
            local token = headers["authorization"]

            if token and sessions[token] then
                local username = sessions[token]
                local users = load_users()

                for _, user in ipairs(users) do
                    if user.username == username then
                        send_json(client, {
                            success = true,
                            password = user.password -- you may want to hide this later
                        })
                        return
                    end
                end

                send_json(client, { success = false, message = "User not found" }, "404 Not Found")
            else
                send_json(client, { success = false, message = "Unauthorized" }, "401 Unauthorized")
            end
            return
        end

        if method == "POST" and path == "/changePassword" then
            local headers, body = read_request(client)
            local token = headers["authorization"]
            print("Token: ", token)
            local data = json.decode(body)

            if token and sessions[token] then
                local username = sessions[token]
                local users = load_users()

                for _, user in ipairs(users) do
                    if user.username == username then
                        user.password = data.newPassword
                        save_users(users)
                        send_json(client, { success = true, message = "Password updated" })
                        return
                    end
                end

                send_json(client, { success = false, message = "User not found" }, "404 Not Found")
            else
                send_json(client, { success = false, message = "Unauthorized" }, "401 Unauthorized")
            end
        end

        -- Default 404
        client:send("HTTP/1.1 404 Not Found\r\n\r\n")
    end

    -- Run the handler
    handle_client()
    client:close()
end
