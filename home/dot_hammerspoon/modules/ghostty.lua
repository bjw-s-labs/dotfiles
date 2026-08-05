-- ghostty.lua
-- Ghostty terminal integration: opens a project directory as a new tab
-- in the running Ghostty instance, or launches Ghostty at that directory
-- when it is not yet running. Uses `open -a` instead of AppleScript so no
-- TCC/Automation permission prompt is required.

return function(config)
    local utils = config.utils

    local openProjectInGhostty = function(path)
        utils.startTask(
            "/usr/bin/open",
            { "-a", "Ghostty", path },
            "Could not open Ghostty tab"
        )
    end

    return {
        openProjectInGhostty = openProjectInGhostty,
    }
end
