-- src/commands.lua

local HttpClient    = require("lib/httpclient")
local JsonEncode    = require("lib/jsonEncode")
local ae2_wireless  = require("lib/ae2")
local Logger        = require("lib/logger")
local Sender        = require("lib/sender")

local Commands      = {}
local conf

function Commands.init(config)
    conf = config
end

function Commands.getItem(itemName, count, slot)
    print(itemName .. " " .. count)
    local _, err = ae2_wireless:takeItem(itemName, tonumber(count), tonumber(slot))
    if err then print(err) end
    Sender.inventoryData()
end

return Commands
