{pkgs, ...}: let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &
  '';
in {
  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = ''${startupScript}/bin/start'';
    };
  };

  home.stateVersion = "23.11"; # do not change - or suffer the consequences

  home.username = "jonasfeld";
  home.homeDirectory = "/home/jonasfeld";

  home.packages = with pkgs; [
    cargo
    rustc
    zsh
    zoxide
    vscodium
    beekeeper-studio

    # messengers
    signal-desktop
    whatsapp-for-linux
    element-desktop
    telegram-desktop

    # work related
    google-chrome
    slack

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    #    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jonasfeld/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
        vim = "nvim";
        edithome = "nvim ~/nixos/home.nix";
        editconf = "nvim ~/nixos/configuration.nix";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        vscodevim.vim
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        kamadorueda.alejandra
        bbenoist.nix
      ];

      # maybe somewhen else
      #            userSettings = {
      #                "workbench.colorCustomizations" = {
      #                    "editorBracketHighlight.foreground1" = "#ffff00";
      #                };
      #                "window.zoomLevel" = 3;
      #                "workbench.iconTheme" = "catppuccin-mocha";
      #                "workbench.colorTheme"= "Catppuccin Mocha";
      #            };
    };

    tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
    };

    alacritty = {
      enable = true;
      settings = {
        font.size = 18;
      };
    };
  };
}
