{
  description = "Personal NixOS flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
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

    nix-colors.url = "github:misterio77/nix-colors";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    # nixpkgs-stable,
    home-manager,
    lanzaboote,
    catppuccin,
    nix-colors,
    nvf,
    ...
  }: let
    system = "x86_64-linux";
    inherit (nixpkgs) lib;
    pkgs-insecure = import nixpkgs {
      inherit system;
      config = {
        permittedInsecurePackages = [
          "beekeeper-studio-5.5.3"
        ];
      };
    };
    # pkgs-stable = import nixpkgs-stable {
    #   inherit system;
    #   config = {
    #     allowUnfree = true;
    #   };
    # };
    colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
    nvim =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs;
          inherit colorScheme;
        };
        modules = [./nvf-configuration.nix];
      }).neovim;

    specialPkgs = {inherit nvim;};
  in {
    packages.${system}.nvim = nvim;

    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit lanzaboote;
          # inherit pkgs-stable;
          inherit specialPkgs;
        };
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit pkgs-insecure;
                # inherit pkgs-stable;
                inherit colorScheme;
                inherit inputs;
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
