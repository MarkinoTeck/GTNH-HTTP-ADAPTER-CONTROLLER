-- src/setup.lua
local HttpClient = require("lib/httpclient")
local JsonEncode = require("lib/jsonEncode")
local computer   = require("computer")
local io         = require("io")
local component  = require("component")
local waypoint   = component.waypoint

local Setup      = {}

local function promptOwner()
    while true do
        io.write("Enter owner id (min. 8 characters): ")
        local input = io.read("*l")
        if input and #input >= 8 then
            return input
        end
        print("Error: id must be valid. Try again.")
    end
end

function Setup.run(conf)
    local owner = conf:get("owner")
    if not owner or type(owner) ~= "string" or #owner < 8 then
        print("=== OWNER SETUP ===")
        owner = promptOwner()
        conf:set("owner", owner)
        conf:save()
        print("Owner saved: " .. owner)
        print("===================")
    end

    if conf:get("configured") then
        print("Configuration already present.")
        print("Owner: " .. tostring(conf:get("owner")))
        print("ID:    " .. tostring(conf:get("id")))
        print("IP:    " .. tostring(conf:get("ip")))
        os.sleep(5)
        waypoint.setLabel(conf:get("id"))
        return true
    end

    -- First boot on the robot: request a new device ID
    print("Requesting new device ID...")

    local payload = {
        owner = owner,
        type = "adapter_controller"
    }

    local response, _ = HttpClient.post(
        conf:get("ip") .. "/getNewDeviceId",
        JsonEncode.encode(payload)
    )

    local new_id = tostring(response)
    if type(new_id) == "string" then
        conf:set("id", new_id)
        conf:set("configured", true)
        conf:save()
        print("Got new ID: " .. new_id)
        print("Rebooting...")
        os.sleep(2)
        computer.shutdown(true)
    else
        print('Error getting ID (invalid response: "' .. tostring(response) .. '")')
        os.exit()
    end
end

return Setup
