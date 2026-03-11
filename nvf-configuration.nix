{
  buildNeovimConfig = {
    modules,
    inputs,
    system,
  }: let
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    inherit (inputs) nvf;
  in
    (nvf.lib.neovimConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        flake = inputs.self;
      };
      modules = [./modules/nvf/basic.nix] ++ modules;
    }).neovim;
}
