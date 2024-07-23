{ pkgs, config, inputs, userSettings, colorScheme, ... }:

{
  programs.waybar = {
    enable = true;
    style = import ./style.nix { inherit colorScheme inputs userSettings; };
  };
  xdg.configFile."waybar/config".text = import ./config.nix { inherit pkgs config; };
}
