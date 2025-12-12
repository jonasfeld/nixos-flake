{
  pkgs,
  inputs,
  ...
}: let
  flake = inputs.self;
in {
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
      servers = {
        "*" = {
          root_markers = [".git"];
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
        };

        texlab = {
          enable = true;
          cmd = ["${pkgs.texlab}/bin/texlab"];
          filetypes = ["tex" "bib"];
        };

        nixd = {
          enable = true;
          init_options = {
            nixpkgs = {
              expr = "import <nixpkgs> {}";
            };
            options = {
              nixos = {
                expr = "(builtins.getFlake \"${flake}\").nixosConfigurations.nixos.options";
              };
              home-manager = {
                expr = "(builtins.getFlake \"${flake}\").nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []";
              };
            };
          };
        };

        clangd = {
          root_markers = ["compile_commands.json" "CMakeLists.txt"];
        };
      };
    };

    treesitter = {
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

      nix = {
        enable = true;
        lsp.servers = ["nixd"];
      };

      python.enable = true;
      rust.enable = true;
      ts.enable = true;
      css.enable = true;
      clang.enable = true;
    };

    statusline = {
      lualine = {
        theme = "catppuccin";
        enable = true;
      };
    };

    notes = {
      todo-comments.enable = true;
    };

    autocomplete = {
      blink-cmp = {
        enable = true;
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

      # motion = {
      #   hop.enable = true;
      #   leap.enable = true;
      # };
    };

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    visuals = {
      nvim-web-devicons.enable = true;
    };

    git = {
      enable = true;
      gitsigns = {
        enable = true;
        mappings = {
          blameLine = "<leader>gb";
          diffProject = "<leader>gD";
          diffThis = "<leader>gd";
          previewHunk = "<leader>gP";
          resetBuffer = "<leader>gR";
          resetHunk = "<leader>gr";
          stageBuffer = "<leader>gS";
          stageHunk = "<leader>gs";
          undoStageHunk = "<leader>gu";
        };
      };
    };

    # show neat icons and different colorings for files
    # changed in git repo
    startPlugins = [pkgs.vimPlugins.oil-git-nvim];

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
      directory = "~/.cache/nvim/swap"; # swap file dir
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
      # setupOpts.tabline = true;
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
    ];
  };
}
