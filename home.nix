{
  pkgs,
  # pkgs-stable,
  pkgs-insecure,
  config,
  ...
}: let
  dev_pkgs = with pkgs; [
    nodejs
    gh
    android-studio
    gnumake
    cmake
    cargo
    rustc
    code-cursor
    cursor-cli
    pkgs-insecure.beekeeper-studio
    jdk17
    gradle_8
    devenv
    python3
    alejandra

    # container stuff
    dive
    distrobox
    distrobox-tui

    # watch files script
    (import ./modules/watchfiles.nix pkgs)
  ];
  user_programs = with pkgs; [
    megasync
    zoxide
    anki-bin
    nautilus
    inkscape
    gimp
    libreoffice
    croc
    qrcp
    pdfarranger
    fastfetch

    ## pain.
    texlive.combined.scheme-full

    ## messengers
    discord
    # zoom-us
    signal-desktop
    wasistlos
    element-desktop
    telegram-desktop
    # mattermost-desktop

    ## work related
    google-chrome
    slack

    ## uni
    # calibre
    eduvpn-client
    jetbrains.idea
    drawio

    ## temporary
    # obs-studio
    vlc

    ## gaming
    prismlauncher
    osu-lazer-bin
  ];
in {
  imports = [
    programs/hyprland.nix
    programs/shell.nix
  ];

  # syncing with syncthing
  services.syncthing.enable = true;

  # Catppuccin
  catppuccin = {
    enable = true;
    sources = {
      cursors = pkgs.catppuccin-cursors.mochaDark;
    };
    cache.enable = true;
    accent = "mauve";
    flavor = "mocha";
    cursors.enable = true;
    cursors.accent = "dark";
  };

  home.pointerCursor.size = 25;

  catppuccin.gtk.icon.enable = true;
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Mauve-Dark";
      package = pkgs.magnetic-catppuccin-gtk.override {
        shade = "dark";
        accent = ["mauve"];
        tweaks = ["float"];
      };
    };
    gtk4.theme = config.gtk.theme;
  };

  services.gnome-keyring.enable = true;

  home.username = "jonasfeld";
  home.homeDirectory = "/home/jonasfeld";

  home.packages = [] ++ user_programs ++ dev_pkgs;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/rofi".source = dots/rofi;
    ".config/kitty".source = dots/kitty;
    ".config/swaync".source = dots/swaync;
    ".config/zathura".source = dots/zathura;
    ".gitconfig".source = dots/git/.gitconfig;
    "matheknecht".source = shells/matheknecht.nix;
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
    neovide = {
      enable = true;
      settings = {
        font = {
          normal = "FiraCode Nerd Font Mono";
          size = 11.0;
        };
      };
    };

    sioyek = {
      enable = true;
      bindings = {
        next_page = "J";
        previous_page = "K";
      };
    };

    ghostty = {
      enable = true;
      enableZshIntegration = true;
      systemd.enable = true;
      settings = {
        font-family = ["FiraCode Nerd Font" "Font Awesome 7 Free Solid"];
        font-size = 11;
        quit-after-last-window-closed = true;
        quit-after-last-window-closed-delay = "5m";
        shell-integration-features = "ssh-terminfo,ssh-env";
      };
    };

    vscode = {
      enable = true;
      package = pkgs.code-cursor;
      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        userSettings = {
          "catppuccin.accentColor" = "mauve";
          "editor.semanticHighlighting.enabled" = true;
          "terminal.integrated.minimumContrastRatio" = 1;
          "terminal.integrated.inheritEnv" = false;
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "window.titleBarStyle" = "custom";

          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "editor.lineNumbers" = "relative";

          "typescript.updateImportsOnFileMove.enabled" = "always";
          "typescript.preferences.importModuleSpecifier" = "relative";
          "[typescript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[typescriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[javascript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[javascriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
          "workbench.colorCustomizations" = {
            "editorBracketHighlight.foreground1" = "#ffff00";
            "editorBracketHighlight.foreground2" = "#40ff00";
            "editorBracketHighlight.foreground3" = "#00ffff";
            "editorBracketHighlight.foreground4" = "#bf00ff";
            "editorBracketHighlight.foreground5" = "#ff00bf";
            "editorBracketHighlight.foreground6" = "#db6165";
            "editorBracketHighlight.unexpectedBracket.foreground" = "#ff0000";
          };

          "git.autofetch" = true;
          "git.confirmSync" = false;

          "vim.handleKeys" = {
            # "<C-a>"= false;
            "<C-f>" = false;
            "<C-b>" = false;
            "<C-p>" = false;
            "<C-n>" = false;
            "<C-k>" = false;
          };
          "workbench.secondarySideBar.defaultVisibility" = "hidden";
          "githubPullRequests.createOnPublishBranch" = "never";
          "redhat.telemetry.enabled" = false;
          "[jsonc]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "gitlens.launchpad.indicator.enabled" = false;
        };
        extensions = with pkgs.vscode-extensions; [
          # github.copilot
          github.vscode-pull-request-github
          vscodevim.vim
          catppuccin.catppuccin-vsc
          kamadorueda.alejandra
          eamodio.gitlens
          esbenp.prettier-vscode
          dart-code.flutter
          dart-code.dart-code
          tamasfe.even-better-toml
          ms-python.vscode-pylance
          ms-python.python
          prisma.prisma
          ms-vscode-remote.remote-ssh
          jnoortheen.nix-ide
          mkhl.direnv
        ];
      };
    };
  };

  home.stateVersion = "23.11"; # do not change - or suffer the consequences
}
