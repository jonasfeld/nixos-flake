{
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    clock24 = true;
    mouse = true;
    shell = lib.getExe pkgs.zsh;
    focusEvents = true;
    terminal = "tmux-256color";
    extraConfig = ''
      bind C-o display-popup -E "tms"
    '';
  };
  home.packages = with pkgs; [
    tmux-sessionizer
  ];
}
