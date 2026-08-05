-- project-chooser.lua
-- Project chooser UI setup: the selection handler that opens the
-- chosen project, and the hs.chooser instance configuration.

return function(config)
    local usage = config.usage
    local ghostty = config.ghostty
    local vscode = config.vscode

    local openSelectedProject = function(choice)
        if not choice then
            return
        end

        -- Capture this immediately, while the selection shortcut is held.
        local modifiers =
            hs.eventtap.checkKeyboardModifiers()

        usage.incrementUsage(choice.path)

        if modifiers.alt then
            ghostty.openProjectInGhostty(choice.path)
        else
            vscode.openProjectInVSCode(choice.path)
        end
    end

    local projectChooser = hs.chooser.new(openSelectedProject)

    projectChooser:placeholderText(
        "Search projects…"
    )

    projectChooser:searchSubText(true)
    projectChooser:rows(10)

    return projectChooser
end
