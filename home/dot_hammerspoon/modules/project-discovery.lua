-- project-discovery.lua
-- Git repository discovery: scans the repository root for .git
-- directories and builds a sorted list of project choices.

return function(config)
    local repoRoot = config.repoRoot
    local utils = config.utils
    local usage = config.usage

    local discoverRepos = function()
        local command = string.format(
            [[
find -L %s -name .git -print -prune 2>/dev/null |
while IFS= read -r git_path; do
    repo="${git_path%%/.git}"

    superproject="$(
        git -C "$repo" rev-parse \
            --show-superproject-working-tree 2>/dev/null
    )"

    if [ -z "$superproject" ]; then
        printf '%%s\n' "$repo"
    fi
done
]],
            utils.shellQuote(repoRoot)
        )

        local output, success = hs.execute(command)

        if not success then
            hs.alert.show("Could not scan Git repositories")
            return {}
        end

        local usageCounts = usage.loadUsage()
        local choices = {}
        local seen = {}

        for path in output:gmatch("[^\r\n]+") do
            path = utils.trim(path)

            if path ~= "" and not seen[path] then
                seen[path] = true

                local relativePath

                if path == repoRoot then
                    relativePath = "."
                elseif path:sub(1, #repoRoot + 1) == repoRoot .. "/" then
                    relativePath = path:sub(#repoRoot + 2)
                else
                    -- Defensive fallback. This should not normally happen.
                    relativePath = path
                end

                local parent, projectName =
                    relativePath:match("^(.*)/([^/]+)$")

                if not projectName then
                    projectName = relativePath
                    parent = "."
                end

                if parent == "" then
                    parent = "."
                end

                table.insert(choices, {
                    text = projectName,
                    subText = parent,
                    path = path,
                    usageCount = tonumber(usageCounts[path]) or 0,
                })
            end
        end

        -- Annotate repos whose path involves a symlink. Ghostty opens the
        -- resolved (physical) directory, so flag the divergence here and
        -- show where the new tab will actually land.
        if #choices > 0 then
            local home = os.getenv("HOME")

            local abbreviate = function(p)
                if home and p:sub(1, #home) == home then
                    return "~" .. p:sub(#home + 1)
                end

                return p
            end

            local paths = {}
            for _, c in ipairs(choices) do
                paths[#paths + 1] = c.path
            end

            local cmd =
                "while IFS= read -r p; do readlink -f \"$p\"; done <<'HSREALPATH_EOF'\n"
                .. table.concat(paths, "\n")
                .. "\nHSREALPATH_EOF"

            local rpOutput = hs.execute(cmd)
            local index = 1

            for line in rpOutput:gmatch("[^\r\n]+") do
                line = utils.trim(line)

                local choice = choices[index]

                if
                    choice
                    and line ~= ""
                    and line ~= choice.path
                then
                    choice.subText = choice.subText
                        .. "  \u{2192}  "
                        .. abbreviate(line)
                end

                index = index + 1
            end
        end

        table.sort(choices, function(a, b)
            if a.usageCount ~= b.usageCount then
                return a.usageCount > b.usageCount
            end

            local aName = a.text:lower()
            local bName = b.text:lower()

            if aName ~= bName then
                return aName < bName
            end

            return a.subText:lower() < b.subText:lower()
        end)

        return choices
    end

    return {
        discoverRepos = discoverRepos,
    }
end
