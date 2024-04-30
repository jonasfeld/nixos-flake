{
  pkgs,
  config,
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
    beekeeper-studio
  ];
  user_programs = with pkgs; [
    zsh
    megasync
    ollama
    zoxide
    anki-bin
    gnome.gnome-calendar
    prismlauncher
    gnome.nautilus

    # messengers
    discord
    zoom-us
    signal-desktop
    whatsapp-for-linux
    element-desktop
    telegram-desktop
    mattermost-desktop

    # work related
    google-chrome
    slack
  ];
  hyprland_pkgs = with pkgs; [
    rofi-wayland # launch menu
    waybar
    pop-icon-theme # icon theme for waybar
    wl-clipboard
    networkmanagerapplet
    pavucontrol # program for sound settings
    swaylock # locking the screen
    imagemagick # screenshots as screen locker
    swayidle # idle screen
    dunst # notifiaction bar
    swww # wallpapers
    brightnessctl # light control
    libnotify # sending notifications
    playerctl # controlling the multimedia player
    pulseaudio # audiocontrol
    grim # screenshots
    slurp # screenshots (selection)
  ];
  rofi_toggle = pkgs.writeShellScript "toggle" ''
    if (pidof rofi)
        then
            pkill rofi
        else
            rofi -show combi
        fi
  '';
  power_menu = pkgs.writeShellScript "power_menu" ''
    CHOICE=`$1 << EOF
    suspend
    lock
    reboot
    poweroff
    exit
    EOF`

    case $CHOICE in
    	suspend)
    		systemctl "suspend"
    		;;
    	lock)
    		swaylock
    		;;
    	reboot)
    		systemctl "reboot"
    		;;
    	poweroff)
    		systemctl "poweroff"
    		;;
    	exit)
    		loginctl "terminate-user" "$USER"
    		;;
    esac
  '';
  lock_cmd = pkgs.writeShellScript "lock_cmd" ''
    LOCKFILE=~/.cache/lockscreen.png
    grim $LOCKFILE;
    convert $LOCKFILE -blur 0x4 $LOCKFILE;
    swaylock --image $LOCKFILE
  '';
  display_off_when_lock = pkgs.writeShellScript "display_off_when_lock" ''
    swayidle -w \
      timeout 10 'if pgrep swaylock; then hyprctl dispatch dpms off; fi' \
      resume 'hyprctl dispatch dpms on' \
      before-sleep '${lock_cmd} -f'
  '';
  idle_lock = pkgs.writeShellScript "idle_lock" ''
    swayidle -w \
      timeout 600 '${lock_cmd} -f' \
      timeout 605 'hyprctl dispatch dpms off' \
      resume 'hyprctl dispatch dpms on'
  '';
  volume_brightness = import ./modules/soundkeys.nix pkgs;
in {
  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "waybar"
        "swww init && swww ${./nix-black-4k.png}"
        "dunst"
        "nm-applet --indicator"
        "blueman-applet"
        "gnome-keyring-daemon --daemonize"
        display_off_when_lock
        idle_lock
      ];

      xwayland.force_zero_scaling = true;

      windowrule = [
        "float,pavucontrol"
        "move 79.5% 42,pavucontrol"
        "size 20% 50%,pavucontrol"
        "float,blueman"
        "move 69.5% 42,blueman"
        "size 30% 50%,blueman"
        # ",pavucontrol"
        # ",pavucontrol"
        # ",pavucontrol"
        # ",pavucontrol"
        # ",pavucontrol"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      monitor = [
        ",preferred,auto,auto"
        "eDP-1,2256x1504,0x0,1.566667"
      ];

      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "ALT, space, killactive"
        "ALT, F4, killactive"
        "$mod, B, pseudo"
        "$mod, F, fullscreen"

        # Move focus
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"

        # alt+tab
        "ALT, TAB, cyclenext,"
        "ALT SHIFT, TAB, cyclenext, prev"
        "ALT, TAB, bringactivetotop,"
        "ALT SHIFT, TAB, bringactivetotop,"
        "$mod, TAB, workspace, e+1"
        "$mod SHIFT, TAB, workspace, e-1"

        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Move active window one workspace to the left or right
        "$mod CONTROL SHIFT, H, movetoworkspace, r-1"
        "$mod CONTROL SHIFT, L, movetoworkspace, r+1"
        "$mod CONTROL, H, workspace, r-1"
        "$mod CONTROL, L, workspace, r+1"

        # Scroll through existing workspaces with mainMod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # next workspace on monitor
        "CONTROL_ALT, right, workspace, m+1"
        "CONTROL_ALT, left, workspace, m-1"

        # fn buttons
        ",XF86AudioMute,         exec, ${volume_brightness} volume_mute"
        ",XF86AudioPlay,         exec, ${volume_brightness} play_pause"
        ",XF86AudioPrev,         exec, ${volume_brightness} prev_track"
        ",XF86AudioNext,         exec, ${volume_brightness} next_track"

        # lock
        "$mod CONTROL_ALT, L, exec, ${lock_cmd}"

        # screenshot
        ", Print, exec, grim -g \"$(slurp -d)\" - | wl-copy"

        # power menu
        "$mod, ESCAPE, exec, ${power_menu} \"rofi -dmenu -p Power-menu\""
      ];

      # repeating commands
      binde = [
        # fn buttons
        ",XF86AudioLowerVolume,  exec, ${volume_brightness} volume_down"
        ",XF86AudioRaiseVolume,  exec, ${volume_brightness} volume_up"
        ",XF86MonBrightnessUp,   exec, ${volume_brightness} brightness_up"
        ",XF86MonBrightnessDown, exec, ${volume_brightness} brightness_down"

        # window resizes
        "CONTROL_ALT,L,resizeactive,40 0"
        "CONTROL_ALT,H,resizeactive,-40 0"
        "CONTROL_ALT,K,resizeactive,0 -40"
        "CONTROL_ALT,J,resizeactive,0 40"
      ];

      bindr = [
        "$mod, Super_L, exec, ${rofi_toggle}"
      ];
      animations = {
        # first_launch_animation = false;
      };

      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 1;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        no_border_on_floating = true;
        resize_on_border = true;
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_invert = true;
        workspace_swipe_cancel_ratio = 0.1;
      };
    };
  };

  home.username = "jonasfeld";
  home.homeDirectory = "/home/jonasfeld";

  home.packages =
    [
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ user_programs
    ++ hyprland_pkgs
    ++ dev_pkgs;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/nvim".source = dots/nvim;
    ".config/rofi".source = dots/rofi;
    ".config/dunst".source = dots/dunst;
    ".config/kitty".source = dots/kitty;
    ".config/waybar".source = dots/waybar;
    ".config/swaylock".source = dots/swaylock;
    ".gitconfig".source = dots/git/.gitconfig;
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
        eamodio.gitlens
        esbenp.prettier-vscode
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

  gtk = {
    enable = true;
    font.name = "Noto Sans";
    theme = {
      name = "Catppuccin-Macchiato-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "compact";
        tweaks = [];
        variant = "macchiato";
      };
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  home.stateVersion = "23.11"; # do not change - or suffer the consequences
}
