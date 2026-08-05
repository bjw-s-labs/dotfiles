-- init.lua
-- Bootstrap: defines paths and the hyper modifier, loads all modules
-- in dependency order, and wires up the hotkeys.

local home = os.getenv("HOME")
local srcRoot = home .. "/dev/src"
local projectUsageFile = home .. "/.hammerspoon/data/project-usage.json"

local hyper = {
    "cmd",
    "ctrl",
    "alt",
    "shift",
}

local utils = require("modules.utils")
local usage = require("modules.project-usage")({ usageFile = projectUsageFile, utils = utils })
local repos = require("modules.project-discovery")({ repoRoot = srcRoot, utils = utils, usage = usage })
local ghostty = require("modules.ghostty")({ utils = utils })
local vscode = require("modules.vscode")({ utils = utils })
local chooser = require("modules.project-chooser")({ usage = usage, ghostty = ghostty, vscode = vscode })

require("modules.keybindings")({ repos = repos, chooser = chooser, hyper = hyper, utils = utils })
