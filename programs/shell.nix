{
  pkgs,
  lib,
  ...
}: let
  home-path = "/home/jonasfeld";
  runInNix = cmd: "(cd ${home-path}/nixos && ${cmd})";
in {
  home.packages = [
    pkgs.walk
  ];

  programs = {
    fd.enable = true;

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
        edithome = runInNix "nvim home.nix";
        editshell = runInNix "nvim programs/shell.nix";
        edithypr = runInNix "nvim programs/hyprland.nix";
        editnvf = runInNix "nix run .#nvimFull modules/nvf || nvim modules/nvf";
        editflake = runInNix "nvim flake.nix";
        editconf = runInNix "nvim configuration.nix";
        editdots = runInNix "nvim dots";
        update = "nix flake update --flake ${home-path}/nixos";
        upgrade = "nh os switch --update";
        rebuild = "nh os switch";
        nixdiff = runInNix "git diff";
        nixgit = "${lib.getExe pkgs.lazygit} -p ${home-path}/nixos";
        nixfmt = "alejandra ${home-path}/nixos";
        lesc = ''LESS="-R" LESSOPEN="|pygmentize -g %s" less'';
        nxs = "nix-shell --run zsh";
        knecht = "nxs ${../shells/matheknecht.nix}";
        run = "${pkgs.writeShellScript "run" "$* &> /dev/null & disown"}";
        silent = "${pkgs.writeShellScript "silent" "$* &> /dev/null"}";
        ll = "cd \"$(walk \"$@\")\"";
        gc = "git clone";
        proxied-fox = "firefox --profile /home/jonasfeld/.mozilla/firefox/skfzecce.proxied &> /dev/null & disown";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
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
