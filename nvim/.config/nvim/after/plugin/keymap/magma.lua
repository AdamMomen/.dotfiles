local Remap = require("adam.keymap")
local nnoremap  = Remap.nnoremap

local nmap = Remap.nmap
local silent = { silent = true }

nnoremap("<leader>r", "<Plug>MagmaEvaluateOperator<CR>", silent)
nnoremap("<leader>ro", "<Plug>MagmaShowOutput<CR>",silent)
