-- project-usage.lua
-- Project usage counters: load/save the usage file and increment
-- usage counts for opened projects.

return function(config)
    local usageFile = config.usageFile
    local utils = config.utils

    local loadUsage = function()
        local contents = utils.readFile(usageFile)

        if not contents or contents == "" then
            return {}
        end

        local success, decoded = pcall(hs.json.decode, contents)

        if not success or type(decoded) ~= "table" then
            print("Ignoring invalid usage file: " .. usageFile)
            return {}
        end

        return decoded
    end

    local saveUsage = function(usage)
        local success, encoded = pcall(
            hs.json.encode,
            usage,
            true
        )

        if not success then
            hs.alert.show("Could not encode project usage")
            print("JSON encoding error: " .. tostring(encoded))
            return false
        end

        return utils.writeFileAtomically(usageFile, encoded)
    end

    local incrementUsage = function(path)
        local usage = loadUsage()

        usage[path] = (tonumber(usage[path]) or 0) + 1

        if not saveUsage(usage) then
            hs.alert.show("Could not save project usage")
        end
    end

    return {
        loadUsage = loadUsage,
        saveUsage = saveUsage,
        incrementUsage = incrementUsage,
    }
end
