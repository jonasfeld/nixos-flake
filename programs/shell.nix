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
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
        vim = "nvim";
        edithome = "nvim ~/nixos/home.nix";
        editflake = "nvim ~/nixos/flake.nix";
        editconf = "nvim ~/nixos/configuration.nix";
        editdots = "nvim ~/nixos/dots";
        update = "nix flake update ~/nixos";
        upgrade = "update && rebuild";
        nixdiff = "(cd ~/nixos && git diff)";
        nixfmt = "alejandra ~/nixos";
        lesc = ''LESS="-R" LESSOPEN="|pygmentize -g %s" less'';
        nxs = "nix-shell --run zsh";
        knecht = "nxs ${../shells/matheknecht.nix}";
        start = "${pkgs.writeShellScript "start" "$* &> /dev/null & disown"}";
        ll = "cd \"$(walk \"$@\")\"";
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
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };
}
