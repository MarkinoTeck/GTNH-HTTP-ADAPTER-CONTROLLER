-- src/commands.lua

local HttpClient    = require("lib/httpclient")
local JsonEncode    = require("lib/jsonEncode")
local Logger        = require("lib/logger")
local Sender        = require("lib/sender")

local Commands      = {}
local conf

function Commands.init(config)
    conf = config
end

function Commands.getItem(example)

end

return Commands
