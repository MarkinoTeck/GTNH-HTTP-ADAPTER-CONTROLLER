---@diagnostic disable: undefined-field, need-check-nil

local fs = require("filesystem")
local serialization = require("serialization")

local Config = {}
Config.__index = Config

-- create a new config object
function Config.new(path, defaults)
    local self = setmetatable({}, Config)
    self.path = path
    self.defaults = defaults

    -- create file if it doesn't exist
    if not fs.exists(path) then
        local file = io.open(path, "w")
        file:write(serialization.serialize(defaults))
        file:close()
    end

    -- load the config
    local file = io.open(path, "r")
    self.data = serialization.unserialize(file:read("*a"))
    file:close()

    return self
end

-- save current config back to file
function Config:save()
    local file = io.open(self.path, "w")
    file:write(serialization.serialize(self.data))
    file:close()
end

function Config:get(key)
    return self.data[key]
end

function Config:set(key, value)
    self.data[key] = value
end

return Config

--[[ EXAMPLE
local Config = require("libs/config")

local defaults = {
    id = false,
    ip = "http://test.url.com",
    configured = false
}

local conf = Config.new("/etc/robot_config.cfg", defaults)
print(conf:get("ip"))

conf:set("configured", false)
conf:save()
]]