{
  pkgs,
  pkgs-stable,
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

    # watch files script
    (import ./modules/watchfiles.nix pkgs)
  ];
  user_programs = with pkgs; [
    megasync
    ollama
    zoxide
    anki-bin
    prismlauncher
    nautilus
    zathura
    obsidian
    inkscape
    gimp
    libreoffice-qt

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
  imports = [./dots/waybar-new ./programs/hyprland.nix programs/shell.nix];

  # Catppuccin
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;
  catppuccin.cursors.accent = "dark";
  catppuccin.cursors.enable = true;
  gtk.enable = true;
  # catppuccin.gtk.enable = true;
  # catppuccin.gtk.gnomeShellTheme = true;

  services.gnome-keyring.enable = true;

  home.username = "jonasfeld";
  home.homeDirectory = "/home/jonasfeld";

  home.packages =
    []
    ++ user_programs
    ++ dev_pkgs;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/nvim".source = dots/nvim;
    ".config/rofi".source = dots/rofi;
    ".config/dunst".source = dots/dunst;
    ".config/kitty".source = dots/kitty;
    ".config/swaylock".source = dots/swaylock;
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

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        github.copilot
        github.vscode-pull-request-github
        vscodevim.vim
        catppuccin.catppuccin-vsc
        # catppuccin.catppuccin-vsc-icons
        kamadorueda.alejandra
        bbenoist.nix
        eamodio.gitlens
        esbenp.prettier-vscode
        dart-code.flutter
        dart-code.dart-code
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
  };

  home.stateVersion = "23.11"; # do not change - or suffer the consequences
}
