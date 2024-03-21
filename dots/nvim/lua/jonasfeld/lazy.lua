local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	"nvim-treesitter/nvim-treesitter",
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    "nvim-lua/plenary.nvim",
    "ThePrimeagen/harpoon",
    "Shatur/neovim-ayu",
    {'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	 -- LSP Support
	 {
		 'VonHeikemen/lsp-zero.nvim',
		 branch = 'v3.x',
		 lazy = true,
		 config = false,
	 },
	 {
		 'neovim/nvim-lspconfig',
		 dependencies = {
			 {'hrsh7th/cmp-nvim-lsp'},
		 }
	 },
	 -- Autocompletion
	 {
		 'hrsh7th/nvim-cmp',
		 dependencies = {
			 {'L3MON4D3/LuaSnip'}
		 },
	 },
})

