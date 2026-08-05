-- utils.lua
-- Generic helper functions: shell quoting, trimming, file I/O,
-- and asynchronous task launching.

local shellQuote = function(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local trim = function(value)
    return value:gsub("^%s+", ""):gsub("%s+$", "")
end

local readFile = function(path)
    local file = io.open(path, "r")

    if not file then
        return nil
    end

    local contents = file:read("*a")
    file:close()

    return contents
end

local writeFileAtomically = function(path, contents)
    local temporaryPath = path .. ".tmp"
    local file, openError = io.open(temporaryPath, "w")

    if not file then
        print(
            "Could not open temporary usage file: "
                .. tostring(openError)
        )
        return false
    end

    file:write(contents)
    file:close()

    local renamed, renameError = os.rename(temporaryPath, path)

    if not renamed then
        print(
            "Could not replace usage file: "
                .. tostring(renameError)
        )
        return false
    end

    return true
end

local startTask = function(executable, arguments, errorMessage)
    local task = hs.task.new(
        executable,
        function(exitCode, standardOutput, standardError)
            if exitCode ~= 0 then
                hs.alert.show(errorMessage)

                print(
                    errorMessage
                        .. "\n"
                        .. tostring(standardError)
                        .. "\n"
                        .. tostring(standardOutput)
                )
            end
        end,
        arguments
    )

    if not task then
        hs.alert.show(errorMessage)
        print("Could not create task for: " .. executable)
        return false
    end

    task:start()
    return true
end

return {
    shellQuote = shellQuote,
    trim = trim,
    readFile = readFile,
    writeFileAtomically = writeFileAtomically,
    startTask = startTask,
}
