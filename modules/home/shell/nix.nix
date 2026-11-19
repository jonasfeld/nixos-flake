{pkgs, ...}: let
  home-path = "/home/jonasfeld";
in {
  home.packages = with pkgs; [nix-output-monitor];
  programs = {
    nh = {
      enable = true;
      flake = "${home-path}/nixos";
    };
  };
}
