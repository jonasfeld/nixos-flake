vim.g.mapleader = " "
vim.keymap.set("n", "<leader>f", vim.cmd.Ex)

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<leader>y", "\"+y")

-- Cursor stays in the middle of the screen when iterating over search terms
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Cursor stays in the middle of the screen when using <C-d> and <C-u>
vim.keymap.set("n", "<C-d>", "<C-d>zzzv");
vim.keymap.set("n", "<C-u>", "<C-u>zzzv");

vim.keymap.set("x", "<leader>p", "\"_DP");

vim.keymap.set("i", "<C-j>", "<Nop>");

-- delete entire words
vim.keymap.set("i", "<C-BS>", "<C-W>");


-- control c pls
vim.keymap.set("i", "<C-c>", "<ESC>");
vim.keymap.set("v", "<C-c>", "<ESC>");
