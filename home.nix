{
  pkgs,
  # pkgs-stable,
  pkgs-insecure,
  ...
}: let
  dev_pkgs = with pkgs; [
    nodejs
    gh
    android-studio
    cmake
    cargo
    rustc
    vscodium
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
    prismlauncher
    nautilus
    obsidian
    inkscape
    gimp
    libreoffice

    # pain.
    texlive.combined.scheme-full

    # messengers
    discord
    # zoom-us
    signal-desktop-bin
    wasistlos
    element-desktop
    telegram-desktop
    mattermost-desktop

    # work related
    google-chrome
    slack

    # uni
    calibre
    eduvpn-client
    jetbrains.idea-ultimate

    # temporary
    obs-studio
    vlc
  ];
in {
  imports = [
    ./programs/hyprland.nix
    programs/shell.nix
  ];

  # syncing with syncthing
  services.syncthing.enable = true;

  # Catppuccin
  catppuccin = {
    enable = true;
    flavor = "mocha";
    cursors.enable = true;
    cursors.accent = "dark";
  };

  home.pointerCursor.size = 25;

  gtk.enable = true;
  catppuccin.gtk.icon.enable = true;
  gtk.theme = {
    name = "Catppuccin-GTK-Purple-Dark";
    package = pkgs.magnetic-catppuccin-gtk.override {
      accent = ["purple"];
      tweaks = ["float"];
    };
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
    GDK_SCALE = "1.566667";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    sioyek = {
      enable = true;
      bindings = {
        next_page = "J";
        previous_page = "K";
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        userSettings = {
          "catppuccin.accentColor" = "mauve";
          "editor.semanticHighlighting.enabled" = true;
          "terminal.integrated.minimumContrastRatio" = 1;
          "window.titleBarStyle" = "custom";

          "nixEnvPicker.envFile" = "\${workspacefolder}\${/}shell.nix";
          "nixEnvPicker.terminalAutoActivate" = true;
          "nixEnvPicker.terminalActivateCommand" = "nxs";

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

          "git.confirmSync" = false;

          "vim.handleKeys" = {
            # "<C-a>"= false;
            "<C-f>" = false;
            "<C-b>" = false;
            "<C-p>" = false;
            "<C-n>" = false;
          };
          "workbench.secondarySideBar.defaultVisibility" = "hidden";
          "githubPullRequests.createOnPublishBranch" = "never";
          "redhat.telemetry.enabled" = false;
          "[jsonc]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
        };
        extensions = with pkgs.vscode-extensions; [
          # github.copilot
          github.vscode-pull-request-github
          vscodevim.vim
          catppuccin.catppuccin-vsc
          kamadorueda.alejandra
          oops418.nix-env-picker
          eamodio.gitlens
          esbenp.prettier-vscode
          dart-code.flutter
          dart-code.dart-code
          tamasfe.even-better-toml
          ms-python.vscode-pylance
          ms-python.python
          # prisma.prisma
        ];
      };
    };
  };

  home.stateVersion = "23.11"; # do not change - or suffer the consequences
}
