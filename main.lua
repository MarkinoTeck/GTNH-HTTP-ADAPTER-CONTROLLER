-- main.lua
local autoUpdate = require("lib/autoupdate")
local version    = require("version")

autoUpdate(
  version,
  "MarkinoTeck/GTNH-HTTP-ADAPTER-CONTROLLER",
  "ServerCode"
)

local Config   = require("lib/config")
local Sender   = require("lib/sender")

local Setup    = require("src/setup")
local Commands = require("src/commands")
local Loop     = require("src/loop")

local DEFAULTS = {
  id         = false,
  ip         = "http://test.lookitsmark.com",
  configured = false,
  owner      = false,
}

local conf = Config.new("/etc/server_config.cfg", DEFAULTS)

Sender.init(conf)
Setup.run(conf)

Commands.init(conf)
Loop.init(conf)

while true do
  Loop.tick()
end
