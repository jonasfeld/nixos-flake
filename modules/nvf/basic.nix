{
  pkgs,
  lib,
  config,
  ...
}: {
  vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      servers."*" = {
        root_markers = [".git"];
        capabilities = {
          textDocument = {
            semanticTokens = {
              multilineTokenSupport = true;
            };
          };
        };
      };
      mappings = {
        renameSymbol = "grn";
        codeAction = "gra";
        goToDeclaration = "grD";
        hover = "grh";
      };
    };

    treesitter = {
      fold = false;
      indent.enable = true;
      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };

    telescope = {
      enable = true;
      extensions = [
        {
          name = "fzf";
          packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
          setup = {fzf = {fuzzy = true;};};
        }
      ];
      mappings = {
        lspReferences = "grr";
        lspImplementations = "gri";
        lspDefinitions = "grd";
        lspTypeDefinitions = "grt";
        findFiles = "<leader>sf";
        liveGrep = "<leader>sg";
        helpTags = "<leader>sh";
      };
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
    };

    statusline = {
      lualine = {
        setupOpts.options.theme = "auto";
        enable = true;
        integrations.breadcrumbs = {
          navbuddy.enable = true;
          nvim-navic.enable = true;
        };
      };
    };

    notes = {
      todo-comments.enable = true;
    };

    autocomplete = {
      blink-cmp = {
        enable = true;
        setupOpts = {
          keymap.preset = "super-tab";
        };
        mappings = lib.mapAttrs (_: _: null) config.vim.autocomplete.blink-cmp.mappings;
        sourcePlugins.emoji.enable = true;
        friendly-snippets.enable = true;
      };
    };

    snippets.luasnip.enable = true;

    utility = {
      oil-nvim = {
        enable = true;
        setupOpts = {
          view_options = {
            show_hidden = true;
          };
        };
      };
    };

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    visuals = {
      nvim-web-devicons.enable = true;
    };

    extraPlugins = {
      guess-indent = {
        package = pkgs.vimPlugins.guess-indent-nvim;
        setup = "require('guess-indent').setup {}";
      };
      oil-git-nvim = {
        package = pkgs.vimUtils.buildVimPlugin {
          # show neat icons and different colorings for files based on git status
          name = "oil-git.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "malewicz1337"; # newer fork than what is availabe in nixpkgs
            repo = "oil-git.nvim";
            rev = "6c92acdbae04dce8a4a2302c3a5dd264bd337456";
            hash = "sha256-WvbfL+bw3jNsI+e6Rjpz4KFwjWort1SJy7u3bEfLrHQ=";
          };
        };
        setup = "require('oil-git').setup {}";
      };
    };

    git = {
      enable = true;
      gitsigns = {
        enable = true;
        mappings = {
          # blameLine = "<leader>gb";
          # diffProject = "<leader>gD";
          # diffThis = "<leader>gd";
          # stageBuffer = "<leader>gS";
          # stageHunk = "<leader>gs";

          # taken from the defaults
          toggleBlame = "<leader>tb";
          toggleDeleted = "<leader>td";
          nextHunk = "]c";
          previousHunk = "[c";

          # mappings i dont want :)
          undoStageHunk = lib.mkForce null;
          resetHunk = lib.mkForce null;
          resetBuffer = lib.mkForce null;
          previewHunk = lib.mkForce null;
        };
      };
    };

    terminal.toggleterm = {
      enable = true;
      lazygit = {
        enable = true;
        mappings.open = "<leader>g";
      };
    };

    ui = {
      illuminate.enable = true;
      fastaction.enable = true;
    };

    options = {
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      ignorecase = true;
      scrolloff = 8;
      swapfile = true;
    };

    navigation.harpoon = {
      enable = true;
      mappings = {
        file1 = "<leader>j";
        file2 = "<leader>k";
        file3 = null;
        file4 = null;
        listMarks = "<leader>h";
        markFile = "<leader>a";
      };
    };

    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    keymaps = [
      {
        key = "-";
        silent = true;
        mode = "n";
        action = ":Oil<CR>";
        desc = "Open file manager";
      }
      {
        key = "<C-BS>";
        silent = true;
        mode = "i";
        action = "<C-w>";
        desc = "Delete word backwards";
        noremap = false;
      }
      {
        key = "<leader>y";
        silent = true;
        mode = "n";
        action = "\"+y";
        desc = "Yank to Clipboard";
      }
      {
        key = "<leader>y";
        silent = true;
        mode = "v";
        action = "\"+y";
        desc = "Yank to Clipboard";
      }
      {
        key = "<leader>p";
        silent = true;
        mode = "n";
        action = "\"+p";
        desc = "Paste from Clipboard";
      }
      {
        key = "<leader>p";
        silent = true;
        mode = "v";
        action = "\"+p";
        desc = "Paste from Clipboard";
      }
      {
        key = "<C-c>";
        silent = true;
        mode = "i";
        action = "<ESC>";
        desc = "Go back to normal mode";
      }
      {
        key = "<C-ESC>";
        silent = true;
        mode = "t";
        action = "<C-\\><C-n>";
        desc = "Go back to normal mode";
      }
      {
        key = "<C-b>";
        silent = true;
        mode = "n";
        action = "";
        # desc = "Disable dumb jumping with <C-b>";
      }
      {
        silent = true;
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
        desc = "Move focus to the left window";
      }
      {
        silent = true;
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
        desc = "Move focus to the right window";
      }
      {
        silent = true;
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
        desc = "Move focus to the lower window";
      }
      {
        silent = true;
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        desc = "Move focus to the upper window";
      }
    ];
  };
}
