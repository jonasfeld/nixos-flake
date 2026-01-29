{pkgs, ...}: let
  home-path = "/home/jonasfeld";
in {
  home.packages = [
    pkgs.walk
  ];

  programs = {
    fd.enable = true;

    ripgrep.enable = true;

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
        edithome = "nvim ${home-path}/nixos/home.nix";
        editshell = "nvim ${home-path}/nixos/programs/shell.nix";
        edithypr = "nvim ${home-path}/nixos/programs/hyprland.nix";
        editnvf = "nix run ${home-path}/nixos#nvim ${home-path}/nixos/nvf-configuration.nix || nvim ${home-path}/nixos/nvf-configuration.nix";
        editflake = "nvim ${home-path}/nixos/flake.nix";
        editconf = "nvim ${home-path}/nixos/configuration.nix";
        editdots = "nvim ${home-path}/nixos/dots";
        update = "nix flake update --flake ${home-path}/nixos";
        upgrade = "nh os switch --update";
        rebuild = "nh os switch";
        nixdiff = "(cd ${home-path}/nixos && git diff)";
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
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };
}
