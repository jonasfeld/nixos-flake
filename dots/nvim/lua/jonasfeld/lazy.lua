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
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },

        config = function()
            require('telescope').setup({})

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<C-f>', builtin.find_files, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
            --vim.keymap.set('n', '<leader>pws', function()
            --    local word = vim.fn.expand("<cword>")
            --    builtin.grep_string({ search = word })
            --end)
            --vim.keymap.set('n', '<leader>pWs', function()
            --    local word = vim.fn.expand("<cWORD>")
            --    builtin.grep_string({ search = word })
            --end)
            --vim.keymap.set('n', '<leader>g', function()
            --    builtin.grep_string({ search = vim.fn.input("Grep > ") })
            --end)
            vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        end
    },
    {
        "dundalek/lazy-lsp.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("lazy-lsp").setup {
                use_vim_lsp_config = true;
                excluded_servers = {
                    "ccls",                            -- prefer clangd
                    "denols",                          -- prefer eslint and tsserver
                    "docker_compose_language_service", -- yamlls should be enough?
                    "flow",                            -- prefer eslint and tsserver
                    "ltex",                            -- grammar tool using too much CPU
                    "quick_lint_js",                   -- prefer eslint and tsserver
                    "rnix",                            -- archived on Jan 25, 2024
                    "scry",                            -- archived on Jun 1, 2023
                    "tailwindcss",                     -- associates with too many filetypes
                    "sourcekit",                       -- spams log
                    "nixd",                            -- prefer nil
                },
                preferred_servers = {
                    -- markdown = {},
                    python = { "pyright", "ruff_lsp" },
                },
                prefer_local = true, -- Prefer locally installed servers over nix-shell
                -- Default config passed to all servers to specify on_attach callback and other options.
                default_config = {
                    flags = {
                        debounce_text_changes = 150,
                    },
                    -- on_attach = on_attach,
                    -- capabilities = capabilities,
                },
                -- Override config for specific servers that will passed down to lspconfig setup.
                -- Note that the default_config will be merged with this specific configuration so you don't need to specify everything twice.
                configs = {
                    lua_ls = {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    -- Get the language server to recognize the `vim` global
                                    globals = { "vim" },
                                },
                            },
                        },
                    },
                },
            }
        end
    },
}, {
    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy.lock"
})

