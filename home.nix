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
    claude-code
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
    tmux-sessionizer
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
    ncdu

    firefox
    thunderbird
    spotify
    keepassxc
    onedrive

    ## pain.
    texlive.combined.scheme-full

    ## messengers
    discord
    # zoom-us
    signal-desktop
    whatsapp-electron # whatsapp
    telegram-desktop
    element-desktop
    # mattermost-desktop

    ## work related
    google-chrome
    slack

    ## uni
    calibre
    eduvpn-client
    jetbrains.idea
    drawio

    ## temporary
    # obs-studio
    vlc
    opencode
    timr-tui
    kicad
    ltspice

    ## gaming
    prismlauncher
    osu-lazer-bin
  ];
in {
  imports = [
    modules/home/hyprland
    modules/home/shell
    modules/home/editors
  ];

  # syncing with syncthing
  services.syncthing.enable = true;

  # Catppuccin
  catppuccin = {
    autoEnable = true;
    enable = true;
    sources = {
      cursors = pkgs.catppuccin-cursors.mochaDark;
    };
    cache.enable = true;
    accent = "mauve";
    flavor = "mocha";
    cursors.enable = true;
    cursors.accent = "dark";
    vscode.profiles.default.enable = false; # build failure -> prefer nixpkgs ver
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
        screen_down = ["J" "<C-d>"];
        screen_up = ["K" "<C-u>"];
        # move_* moves the camera, not the document
        move_right = "h";
        move_left = "l";
        noop = "q"; # unbind the weird "quit all instances" button
      };
      config = {
        move_screen_ratio = "0.5";
        should_launch_new_window = "1";
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
  };

  home.stateVersion = "23.11"; # do not change - or suffer the consequences
}
