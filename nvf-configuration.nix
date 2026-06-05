{
  buildNeovimConfig = {
    modules,
    inputs,
    extraSpecialArgs,
    system,
  }: let
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    inherit (inputs) nvf;
  in
    (nvf.lib.neovimConfiguration {
      inherit pkgs extraSpecialArgs;
      modules = [./modules/nvf/basic.nix] ++ modules;
    }).neovim;
}
