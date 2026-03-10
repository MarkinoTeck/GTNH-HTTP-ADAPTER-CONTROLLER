-- lib/sender.lua
local HttpClient = require("lib/httpclient")
local JsonEncode = require("lib/jsonEncode")

local Sender = {}
local conf

function Sender.init(config)
    conf = config
end

local function baseUrl() return conf:get("ip")    end
local function robotId() return conf:get("id")     end

local function post(endpoint, body)
    return HttpClient.post(baseUrl() .. endpoint, body)
end

function Sender.error(errorMsg)
    print("Sending error to server...")
    post("/postError", '{"error":"' .. errorMsg .. '","id":"' .. robotId() .. '","thing":' .. "cool!" .. '}')
    print("Done.")
end

function Sender.message(msgType, msgNumber, msgString)
    print("Sending message...")
    local message = JsonEncode.encode({ type = msgType, number = msgNumber, string = msgString })
    post("/postMessage", '{"id":"' .. robotId() .. '","message":' .. message .. '}')
    print("Done.")
end

return Sender
