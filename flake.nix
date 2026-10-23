{
  description = "Personal NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.ndg.inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    basix = {
      url = "github:notashelf/basix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs @ {
    nixpkgs,
    # nixpkgs-stable,
    home-manager,
    lanzaboote,
    catppuccin,
    basix,
    ...
  }: let
    system = "x86_64-linux";
    inherit (nixpkgs) lib;
    pkgs-insecure = import nixpkgs {
      inherit system;
      config = {
        permittedInsecurePackages = [
          "beekeeper-studio-6.1.4"
        ];
      };
    };

    # pkgs-stable = import nixpkgs-stable {
    #   inherit system;
    #   config = {
    #     allowUnfree = true;
    #   };
    # };

    # The one place a theme is chosen. Any base16 scheme in
    # `basix.schemeData.base16` works; consumers are nvf, GTK and waybar.
    basixScheme = "catppuccin-mocha";
    colorScheme = basix.schemeData.base16.${basixScheme};
    gtkTheme = {
      name = basix.lib.mkThemeName basixScheme;
      package = basix.themePackages.${system}.base16.${basixScheme};
    };

    buildNeovimConfig = {
      modules,
      extraSpecialArgs ? {},
    }:
      (import ./nvf-configuration.nix).buildNeovimConfig {
        inherit inputs;
        inherit system;
        inherit modules;
        inherit extraSpecialArgs;
      };

    nvims = {
      nvimFull = buildNeovimConfig {
        modules = lib.filesystem.listFilesRecursive ./modules/nvf/languages;
        extraSpecialArgs = {flake = "/home/jonasfeld/nixos/";};
      };

      nvimPython = buildNeovimConfig {
        modules = [./modules/nvf/languages/python.nix];
      };
    };

    special-pkgs = {
      nvim = nvims.nvimFull;
    };
  in {
    packages.${system} = nvims;

    lib.${system} = {
      inherit buildNeovimConfig;
    };

    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit lanzaboote;
          # inherit pkgs-stable;
          inherit special-pkgs;
        };
        modules = [
          catppuccin.nixosModules.catppuccin
          ./hosts/nixos
          ./configuration.nix
          ./modules/nixos/common
          # ./modules/displaylink.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit pkgs-insecure;
                # inherit pkgs-stable;
                inherit colorScheme;
                inherit gtkTheme;
                inherit inputs;
                inherit special-pkgs;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.jonasfeld = {
                imports = [
                  ./home.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
            };
          }
        ];
      };
    };
  };
}
