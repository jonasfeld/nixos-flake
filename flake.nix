{
  description = "Personal NixOS flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

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

    stylix = {
      url = "github:nix-community/stylix";
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
    stylix,
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

    # The one place a theme is chosen: any name in pkgs.base16-schemes
    # (all of them also exist in basix, which supplies the palette as pure Nix).
    # Stylix reads `file`; everything it can't reach reads `scheme.palette`.
    theme = rec {
      name = "kanagawa";
      scheme = basix.schemeData.base16.${name};
      file = "${nixpkgs.legacyPackages.${system}.base16-schemes}/share/themes/${name}.yaml";
      wallpaper = with scheme.palette;
        nixpkgs.legacyPackages.${system}.runCommand "wallpaper-${name}.png" {
          nativeBuildInputs = [nixpkgs.legacyPackages.${system}.imagemagick];
        } ''
          magick ${./assets/nix-black-4k.png} \
            -fuzz 4% -fill "${base0D}" -opaque "#96cdfb" -fill "${base0C}" -opaque "#89dceb" \
            -fuzz 25% -fill "${base00}" -opaque "#1e1e2e" \
            $out
        '';
    };

    buildNeovimConfig = {
      modules,
      extraSpecialArgs ? {},
    }:
      (import ./nvf-configuration.nix).buildNeovimConfig {
        inherit inputs;
        inherit system;
        inherit modules;
        extraSpecialArgs = {inherit theme;} // extraSpecialArgs;
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
          inherit theme;
          inherit special-pkgs;
        };
        modules = [
          stylix.nixosModules.stylix
          ./hosts/nixos
          ./configuration.nix
          ./modules/nixos/common
          ./modules/displaylink.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit pkgs-insecure;
                inherit theme;
                inherit inputs;
                inherit special-pkgs;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.jonasfeld = {
                imports = [./home.nix];
              };
            };
          }
        ];
      };
    };
  };
}
