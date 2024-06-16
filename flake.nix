{
  description = "Personal NixOS flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    alejandra,
    ...
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs-insecure = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-28.3.1"
        ];
      };
    };
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit pkgs-insecure;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jonasfeld = {
              imports = [./home.nix];
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
