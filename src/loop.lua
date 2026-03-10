-- src/loop.lua
local HttpClient = require("lib/httpclient")
local Utils      = require("lib/utils")
local Sender     = require("lib/sender")
local Commands   = require("src/commands")

local Loop = {}
local conf

function Loop.init(config)
    conf = config
end

local function dispatch(parts)
    local command = parts[1]

    if command == "wait-a-bit"
        then os.sleep(10)

    else
        print("Unknown command: " .. tostring(command))
    end
end

function Loop.tick()
    local raw = HttpClient.get(conf:get("ip") .. "/coda/" .. conf:get("id"))

    if raw == nil then
        return
    end

    raw = raw:gsub("%s+", "")

    if raw == "" then
        os.sleep(5)
        return
    end

    print(raw)
    dispatch(Utils.split(raw, ","))
end

return Loop
