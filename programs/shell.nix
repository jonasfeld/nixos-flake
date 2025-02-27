{pkgs, ...}: let
  walk = pkgs.buildGoModule {
    src = pkgs.fetchFromGitHub {
      owner = "antonmedv";
      repo = "walk";
      rev = "v1.10.0";
      hash = "sha256-wGiRMNgp5NZVj8ILyQ2C/iqpjv4XgphRfWcF/CSMj48=";
    };
    name = "walk";
    vendorHash = "sha256-MTM7zR5OYHbzAm07FTLvXVnESARg50/BZrB2bl+LtXM=";
  };
  home-path = "/home/jonasfeld";
in {
  home.packages = [
    walk
  ];

  programs = {
    fd.enable = true;

    ripgrep.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ${home-path}/nixos";
        vim = "nvim";
        edithome = "nvim ${home-path}/nixos/home.nix";
        editflake = "nvim ${home-path}/nixos/flake.nix";
        editconf = "nvim ${home-path}/nixos/configuration.nix";
        editdots = "nvim ${home-path}/nixos/dots";
        update = "nix flake update --flake ${home-path}/nixos";
        upgrade = "update && rebuild";
        nixdiff = "(cd ${home-path}/nixos && git diff)";
        nixfmt = "alejandra ${home-path}/nixos";
        lesc = ''LESS="-R" LESSOPEN="|pygmentize -g %s" less'';
        nxs = "nix-shell --run zsh";
        knecht = "nxs ${../shells/matheknecht.nix}";
        run = "${pkgs.writeShellScript "run" "$* &> /dev/null & disown"}";
        silent = "${pkgs.writeShellScript "silent" "$* &> /dev/null"}";
        ll = "cd \"$(walk \"$@\")\"";
        gc = "git clone";
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
