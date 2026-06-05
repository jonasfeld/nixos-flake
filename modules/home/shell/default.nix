{
  pkgs,
  lib,
  ...
}: let
  home-path = "/home/jonasfeld";
  runInNix = cmd: "(cd ${home-path}/nixos && ${cmd})";
in {
  programs = {
    fd.enable = true;
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        add_newline = false;
        format = "$directory$character";
        right_format = "$all";
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };

        direnv = {
          disabled = false;
          format = "[$symbol$allowed]($style) ";
          allowed_msg = "allowed";
          denied_msg = "denied";
        };

        nix_shell = {
          format = "via [$symbol \\(nix-shell\\)]($style) ";
          symbol = "❄️";
        };
      };
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      shellWrapperName = "y";
    };

    ripgrep.enable = true;

    lazygit = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    nh = {
      enable = true;
      flake = "${home-path}/nixos";
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      shellAliases = {
        pdf = "sioyek";
        vim = "nvim";
        editnix = runInNix "nvim .";
        edithome = runInNix "nvim modules/home";
        edithypr = runInNix "nvim modules/home/hyprland";
        editnvf = runInNix "nix run .#nvimFull modules/nvf || nvim modules/nvf";
        editflake = runInNix "nvim flake.nix";
        editdots = runInNix "nvim dots";
        update = "nix flake update --flake ${home-path}/nixos";
        upgrade = "nh os switch --update";
        rebuild = "nh os switch";
        nixdiff = runInNix "git diff";
        nixgit = "${lib.getExe pkgs.lazygit} -p ${home-path}/nixos";
        nxs = "nix-shell --run zsh";
        knecht = "nxs ${../../../shells/matheknecht.nix}";
        run = "${pkgs.writeShellScript "run" "$* &> /dev/null & disown"}";
        silent = "${pkgs.writeShellScript "silent" "$* &> /dev/null"}";
        gc = "git clone";
        proxied-fox = "firefox --profile /home/jonasfeld/.mozilla/firefox/skfzecce.proxied &> /dev/null & disown";
      };
    };

    tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
      clock24 = true;
      mouse = true;
      shell = lib.getExe pkgs.zsh;
    };
  };
}
