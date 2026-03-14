-- lib/utils.lua
local Utils = {}

function Utils.split(str, sep)
    local parts = {}
    for part in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(parts, part)
    end
    return parts
end

function Utils.detectExportBusSide(exportbus, isFluid)
    local targetSide = nil

    if isFluid then
        for s = 0, 5 do
            local raw, err = exportbus.getFluidExportConfiguration(s, 1)
            if err ~= "no fluid export bus" and err ~= "no matching part" and err ~= "no export bus" then
                targetSide = s
                print(string.format("[TARGET] Fluid Export Bus on ForgeDirection side %d", s))
                break
            end
        end
    else
        for s = 0, 5 do
            local raw, err = exportbus.getExportConfiguration(s, 1)
            if err ~= "no export bus" and err ~= "no matching part" then
                targetSide = s
                print(string.format("[TARGET] Export Bus found on ForgeDirection side %d", s))
                break
            end
        end
    end

    return targetSide
end

function Utils.applyItemFilters(exportbus, database, filters, numSlots)
    numSlots = numSlots or 9

    print("=== Applying item filters ===")

    -- Detect TARGET bus side on the adapter
    local targetSide = Utils.detectExportBusSide(exportbus, false)
    if targetSide == nil then
        print("[ERROR] No Export Bus found on adapter")
        return false
    end

    -- Apply filters to each slot
    for slot = 1, numSlots do
        local f = filters[slot]

        if f == nil then
            print(string.format("  [%d] (empty) — skipping", slot))
        elseif type(f) == "table" then
            -- Support both naming conventions
            local itemName   = f.itemName or f.name
            local itemDamage = f.itemDamage or f.damage or 0
            local label      = f.label or itemName or "?"

            if itemName then
                local setOk, setErr = database.set(slot, itemName, itemDamage)
                if not setOk then
                    print(string.format("  [%d] WARN  database.set failed for '%s': %s",
                        slot, label, tostring(setErr)))
                end

                local applyOk, applyErr = exportbus.setExportConfiguration(
                    targetSide, slot, database.address, slot
                )
                if applyOk then
                    print(string.format("  [%d] OK    %-32s (%s @ %d)",
                        slot, label, itemName, itemDamage))
                else
                    print(string.format("  [%d] FAIL  %s — %s",
                        slot, label, tostring(applyErr)))
                end
            else
                print(string.format("  [%d] SKIP  slot has no itemName", slot))
            end
        else
            print(string.format("  [%d] unexpected type: %s", slot, type(f)))
        end
    end

    print("=== Item filter application complete ===")
    return true
end

function Utils.applyFluidFilters(exportbus, database, filters, numSlots)
    numSlots = numSlots or 9

    print("=== Applying fluid filters ===")

    -- Detect TARGET bus side on the adapter
    local targetSide = Utils.detectExportBusSide(exportbus, true)
    if targetSide == nil then
        print("[ERROR] No Fluid Export Bus found on adapter")
        return false
    end

    -- Apply filters to each slot
    for slot = 1, numSlots do
        local f = filters[slot]

        if f == nil then
            print(string.format("  [%d] (empty) — skipping", slot))
        elseif type(f) == "table" then
            local fluidName   = f.name or "?"
            local displayName = f.displayName or fluidName
            local itemName    = f.itemName
            local itemDamage  = f.itemDamage or 0

            if itemName then
                local setOk, setErr = database.set(slot, itemName, itemDamage)
                if not setOk then
                    print(string.format("  [%d] WARN  database.set failed for '%s': %s",
                        slot, displayName, tostring(setErr)))
                end

                local applyOk, applyErr = exportbus.setFluidExportConfiguration(
                    targetSide, slot, database.address, slot
                )
                if applyOk then
                    print(string.format("  [%d] OK    %-28s (%s)", slot, displayName, fluidName))
                else
                    print(string.format("  [%d] FAIL  %s — %s", slot, displayName, tostring(applyErr)))
                end
            else
                print(string.format("  [%d] SKIP  %-28s no container registered for '%s'",
                    slot, displayName, fluidName))
                print(string.format("             Fix: put its filled bucket/cell in database slot %d", slot))
            end
        else
            print(string.format("  [%d] unexpected type: %s", slot, type(f)))
        end
    end

    print("=== Fluid filter application complete ===")
    return true
end

function Utils.applyFilters(filterType, filterData)
    local component = require("component")
    local database = component.database

    if not component.isAvailable("database") then
        print("[ERROR] Database component not available")
        return false
    end

    -- Ensure filters is a table
    if type(filterData) ~= "table" then
        print("[ERROR] Filter data is not a table: " .. type(filterData))
        return false
    end

    if filterType == "item" then
        if not component.isAvailable("me_exportbus") then
            print("[ERROR] Item export bus not available")
            return false
        end

        local exportbus = component.me_exportbus
        return Utils.applyItemFilters(exportbus, database, filterData)

    elseif filterType == "fluid" then
        if not component.isAvailable("me_fluid_exportbus") then
            print("[ERROR] Fluid export bus not available")
            return false
        end

        ---@diagnostic disable-next-line: undefined-field
        local exportbus = component.me_fluid_exportbus
        return Utils.applyFluidFilters(exportbus, database, filterData)
    else
        print("[ERROR] Unknown filter type: " .. tostring(filterType))
        return false
    end
end

function Utils.parseJson(jsonData)
    local ok, filterData
    ok, filterData = pcall(function()
        -- Normalize JSON: convert single quotes to double quotes
        -- This handles JSON from JavaScript that may use single quotes
        local normalized = jsonData:gsub("'", '"')

        -- Parse using load (Lua 5.4)
        return load("return " .. normalized)()
    end)

    return ok, filterData
end

return Utils
