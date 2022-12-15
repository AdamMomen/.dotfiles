local Worktree = require("git-worktree")
local Job = require("plenary.job")
local Path = require("plenary.path")

local function is_plumdash()
    return not not (string.find(vim.loop.cwd(), vim.env.PLUMDASH, 1, true))
end

local function get_nrdp_build_paths(path)
    return
        Path:new({vim.env.PLUMDASH, path, "configure"}):absolute()
        -- Path:new({vim.env.NRDP, "build", path}):absolute()
end

Worktree.on_tree_change(function(op, path)

    if op == Worktree.Operations.Switch and is_plumdash() then
        Job:new({
            "./tvui", "install"
        }):start()
    end
    -- Setup come things that we you would like to do when the
    if op == Worktree.Operations.Create and is_plumdash() then
        local submodule = Job:new({
            "git", "submodule", "update"
        })

        local configure_path, build_path = get_nrdp_build_paths(path)
        local make_build = Job:new({
            "mkdir", "-p", build_path
        })

        local configure = Job:new({
            configure_path, "--ninja", "--debug",
            cwd = build_path,
        })

        submodule:and_then_on_success(make_build)
        make_build:and_then_on_success(configure)
        submodule:start()
    end
end)

