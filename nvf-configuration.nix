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
      servers.nixd.init_options = {
        nixpkgs = {
          expr = "import ${inputs.nixpkgs} {}";
        };
        options = {
          nixos = {
            expr = "(builtins.getFlake \"${flake}\").nixosConfigurations.nixos.options";
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

      nix = {
        enable = true;
        lsp.servers = ["nixd"];
        treesitter.enable = true;
      };
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

    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };
  };
}
