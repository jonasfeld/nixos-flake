{
  pkgs,
  lib,
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
    };

    treesitter = {
      fold = true;
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
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
    };

    statusline = {
      lualine = {
        theme = "auto";
        enable = true;
      };
    };

    notes = {
      todo-comments.enable = true;
    };

    autocomplete = {
      blink-cmp = {
        enable = true;
        sourcePlugins.emoji.enable = true;
        friendly-snippets.enable = true;
        mappings = {
          next = "<C-j>";
          previous = "<C-k>";
        };
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
      motion.leap = {
        enable = true;
        mappings = {
          leapForwardTo = "f";
          leapBackwardTo = "F";
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

    startPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        # show neat icons and different colorings for files based on git status
        name = "oil-git.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "malewicz1337"; # newer fork than what is availabe in nixpkgs
          repo = "oil-git.nvim";
          rev = "6c92acdbae04dce8a4a2302c3a5dd264bd337456";
          hash = "sha256-WvbfL+bw3jNsI+e6Rjpz4KFwjWort1SJy7u3bEfLrHQ=";
        };
      })
    ];

    git = {
      enable = true;
      gitsigns = {
        enable = true;
        mappings = {
          blameLine = "<leader>gb";
          diffProject = "<leader>gD";
          diffThis = "<leader>gd";
          stageBuffer = "<leader>gS";
          stageHunk = "<leader>gs";

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
      lazygit.enable = true;
    };

    ui = {
      illuminate.enable = true;
      breadcrumbs.enable = true;
      breadcrumbs.navbuddy.enable = true;
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
    ];
  };
}
