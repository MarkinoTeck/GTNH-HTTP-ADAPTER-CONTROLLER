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

local function dispatch(raw)
    -- Split only on first two commas to preserve JSON
    local command, filterType, jsonData

    local comma1 = raw:find(",", 1, true)
    if comma1 then
        command = raw:sub(1, comma1 - 1):match("^%s*(.-)%s*$")
        local rest = raw:sub(comma1 + 1)

        local comma2 = rest:find(",", 1, true)
        if comma2 then
            filterType = rest:sub(1, comma2 - 1):match("^%s*(.-)%s*$")
            jsonData = rest:sub(comma2 + 1):match("^%s*(.-)%s*$")
        else
            filterType = rest:match("^%s*(.-)%s*$")
        end
    else
        command = raw:match("^%s*(.-)%s*$")
    end

    if command == "wait-a-bit" then
        os.sleep(10)

    elseif command == "apply-filters" then
        if not filterType or not jsonData then
            print("[ERROR] apply-filters requires type and JSON data")
            return
        end

        -- Parse JSON using utility function
        local ok, filterData = Utils.parseJson(jsonData)

        if not ok then
            print("[ERROR] Failed to parse filter data: " .. tostring(filterData))
            return
        end

        Utils.applyFilters(filterType, filterData)

    else
        print("[WARN] Unknown command: " .. tostring(command))
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

    dispatch(raw)
end

return Loop
