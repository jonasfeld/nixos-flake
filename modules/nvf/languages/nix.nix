# assume self is passed from a nixos system flake
{self, ...}: let
  flake = self;
in {
  vim = {
    lsp.servers.nixd = {
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
    languages.nix = {
      enable = true;
      lsp.servers = ["nixd"];
    };
  };
}
