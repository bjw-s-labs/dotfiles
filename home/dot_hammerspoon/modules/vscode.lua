-- vscode.lua
-- Visual Studio Code integration: opens a project directory in VS Code.

return function(config)
    local utils = config.utils

    local openProjectInVSCode = function(path)
        hs.execute(
            string.format(
                "code %s",
                utils.shellQuote(path)
            ),
            true
        )
    end

    return {
        openProjectInVSCode = openProjectInVSCode,
    }
end
