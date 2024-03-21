vim.g.mapleader = " "
vim.keymap.set("n", "<leader>f", vim.cmd.Ex)

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "Y", "\"+y")

-- Cursor stays in the middle of the screen when iterating over search terms
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Cursor stays in the middle of the screen when using <C-d> and <C-u>
vim.keymap.set("n", "<C-d>", "<C-d>zzzv");
vim.keymap.set("n", "<C-u>", "<C-u>zzzv");

vim.keymap.set("x", "<leader>p", "\"_DP")

vim.keymap.set("n", "Q", "<Nop>")
vim.keymap.set("n", "Q", "<Nop>")

vim.keymap.set("i", "<C-j>", "<Nop>")
