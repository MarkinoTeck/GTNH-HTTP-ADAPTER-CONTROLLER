-- src/loop.lua
local HttpClient = require("lib/httpclient")
local Utils      = require("lib/robot_utils")
local Sender     = require("lib/sender")
local Commands   = require("src/commands")

local Loop = {}
local conf

function Loop.init(config)
    conf = config
end

local function dispatch(parts)
    local command = parts[1]

    if command == "wait-a-bit" then
        os.sleep(10)

    elseif command == "apply-filters" then
        -- Format: apply-filters,<type>,<json_data>
        if #parts < 3 then
            print("[ERROR] apply-filters requires type and data")
            return
        end

        local filterType = parts[2]
        -- Rejoin remaining parts in case JSON has commas
        local jsonData = table.concat(parts, ",", 3)

        -- Parse JSON using utility function
        local ok, filterData = Utils.parseJson(jsonData)

        if not ok then
            print("[ERROR] Failed to parse filter data: " .. tostring(filterData))
            return
        end

        Utils.applyFilters(filterType, filterData)

    else
        print("Unknown command: " .. tostring(command))
    end
end

function Loop.tick()
    local raw = HttpClient.get(conf:get("ip") .. "/coda/adapter/" .. conf:get("id"))

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