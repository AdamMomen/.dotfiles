-- File explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open netrw" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Better navigation
vim.keymap.set("n", "Y", "yg$", { desc = "Yank to end of line" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search centered" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines keep cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up centered" })

-- Paste without losing register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Delete without yank
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Escape alternatives
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Prev quickfix" })

-- Window navigation
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Window left" })

-- Quick access to config files
vim.keymap.set("n", "<leader>2", "<cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
vim.keymap.set("n", "<leader>3", "<cmd>e ~/.zsh_profile<CR>", { desc = "Edit .zsh_profile" })
vim.keymap.set("n", "<leader>8", "<cmd>e ~/.tmux.conf<CR>", { desc = "Edit tmux.conf" })

-- Splits
vim.keymap.set("n", "<leader>/", "<cmd>split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>m", "<cmd>Mason<CR>", { desc = "Open Mason" })

-- Tab navigation
vim.keymap.set("n", "<", "<cmd>tabprev<CR>", { desc = "Previous tab" })
vim.keymap.set("n", ">", "<cmd>tabnext<CR>", { desc = "Next tab" })

-- Window resizing
vim.keymap.set("n", "<leader><left>", "<C-w>>", { desc = "Increase width" })
vim.keymap.set("n", "<leader><right>", "<C-w><", { desc = "Decrease width" })
vim.keymap.set("n", "<leader><up>", "<C-w>+", { desc = "Increase height" })
vim.keymap.set("n", "<leader><down>", "<C-w>-", { desc = "Decrease height" })

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

-- Lazy.nvim
vim.keymap.set("n", "<leader>1", "<cmd>Lazy<CR>", { desc = "Open Lazy" })

-- Test icons (diagnostic command)
vim.keymap.set("n", "<leader>ti", function()
    local devicons = require("nvim-web-devicons")
    local test_files = { "test.js", "test.py", "test.lua", "test.md", "test.json" }
    local output = {}
    table.insert(output, "Icon Test (if you see boxes or question marks, install a Nerd Font):")
    table.insert(output, "")
    for _, file in ipairs(test_files) do
        local icon, color = devicons.get_icon_color(file)
        if icon then
            table.insert(output, string.format("%s %s (color: %s)", icon, file, color or "default"))
        else
            table.insert(output, string.format("? %s (no icon found)", file))
        end
    end
    table.insert(output, "")
    table.insert(output, "If icons don't show, install a Nerd Font from: https://www.nerdfonts.com/")
    table.insert(output, "Then set it as your terminal font and restart nvim.")
    vim.notify(table.concat(output, "\n"), vim.log.levels.INFO, { title = "Icon Test" })
end, { desc = "Test icons" })
