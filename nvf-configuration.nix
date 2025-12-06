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
      };
    };

    treesitter = {
      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
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
      blink-cmp.enable = true;
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

      motion = {
        hop.enable = true;
        leap.enable = true;
      };
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
      gitsigns.enable = true;
    };

    ui = {
      illuminate.enable = true;
      breadcrumbs.enable = true;
      breadcrumbs.navbuddy.enable = true;
      fastaction.enable = true;
    };

    options = {
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      smartindent = true;
      ignorecase = true;
      scrolloff = 8;
    };

    spellcheck = {
      programmingWordlist.enable = true;
    };
    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };
    keymaps = [
      {
        key = "<leader>f";
        silent = true;
        mode = "n";
        action = ":Oil<CR>";
        desc = "Open file manager";
      }
    ];
  };
}
