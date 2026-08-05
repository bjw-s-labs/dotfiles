-- keybindings.lua
-- Keyboard shortcut bindings: project chooser toggle, lock screen,
-- paste history, and new Ghostty tab at home.

return function(config)
    local repos = config.repos
    local projectChooser = config.chooser
    local hyper = config.hyper
    local utils = config.utils

    hs.hotkey.bind(hyper, "p", function()
        local choices = repos.discoverRepos()

        if #choices == 0 then
            hs.alert.show(
                "No Git repositories found in ~/dev/src"
            )
            return
        end

        projectChooser:choices(choices)
        projectChooser:show()
    end)

    hs.hotkey.bind(hyper, "l", function()
        hs.eventtap.keyStroke({"ctrl", "cmd"}, "q")
    end)

    hs.hotkey.bind({ "cmd", "ctrl", "alt" }, "v", function()
        hs.eventtap.keyStrokes(hs.pasteboard.getContents() or "")
    end)

    hs.hotkey.bind(hyper, "return", function()
        utils.startTask(
            "/usr/bin/open",
            { "-a", "Ghostty", os.getenv("HOME") },
            "Could not open Ghostty"
        )
    end)

    return true
end
