{
  pkgs,
  lib,
  config,
  inputs,
  userSettings,
  theme,
  ...
}: {
  stylix.targets.waybar.enable = false; # style.nix is hand-written on theme.scheme.palette

  programs.waybar = {
    enable = true;
    style = import ./style.nix {inherit theme inputs userSettings;};
  };
  xdg.configFile."waybar/config".text = import ./config.nix {inherit pkgs lib config;};
}
