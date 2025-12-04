{
  description = "Personal NixOS flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    catppuccin.url = "github:catppuccin/nix";
    nix-colors.url = "github:misterio77/nix-colors";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      alejandra,
      lanzaboote,
      catppuccin,
      nix-colors,
      ...
    }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs-insecure = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "beekeeper-studio-5.3.4"
            # "electron-28.3.3"
          ];
        };
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit lanzaboote;
            inherit pkgs-stable;
          };
          modules = [
            ./configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit pkgs-insecure;
                inherit colorScheme;
                inherit inputs;
                inherit pkgs-stable;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.jonasfeld = {
                imports = [
                  ./home.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
            }

            {
              environment.systemPackages = [ alejandra.defaultPackage.${system} ];
            }
          ];
        };
      };
    };
}
