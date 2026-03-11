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
        inherit inputs;
      };
      modules = [./modules/nvf/basic.nix] ++ modules;
    }).neovim;
}
