{
  lib,
  pkgs,
  theme,
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
      # stylix's tinted-tmux theme doesn't style popups, so they fall back to grey
      set -g popup-style "fg=${theme.scheme.palette.base05},bg=${theme.scheme.palette.base00}"
      set -g popup-border-style "fg=${theme.scheme.palette.base0E}"
    '';
  };
  home.packages = with pkgs; [
    tmux-sessionizer
  ];
}
