{
  description = "Personal NixOS flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    alejandra,
    lanzaboote,
    catppuccin,
    nix-colors,
    ...
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs-insecure = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          # "electron-28.3.3"
        ];
      };
   };
   colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit lanzaboote;
        };
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit pkgs-insecure;
              inherit colorScheme;
              inherit inputs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jonasfeld = {
              imports = [
                ./home.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            };
          }

          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
        ];
      };
    };
  };
}
