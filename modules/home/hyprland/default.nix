{
  pkgs,
  lib,
  ...
}: {
  imports = [./waybar];

  xdg.portal = {
    enable = true;
    configPackages = [pkgs.hyprland];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  home.packages = with pkgs; [
    rofi # launch menu
    wl-clipboard # command-line copy and paste
    networkmanagerapplet
    pavucontrol # program for sound settings
    hyprlock # locking the screen
    imagemagick # screenshots as screen locker
    hypridle # idle screen
    swaynotificationcenter # notification bar
    awww # wallpapers
    brightnessctl # light control
    libnotify # sending notifications
    playerctl # controlling the multimedia player
    pulseaudio # audiocontrol
    grimblast
    satty
    grim # screenshots
    slurp # screenshots (selection)
    copyq # clipboard history
    hyprcursor
    hyprmon # monitor config TUI
  ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 10;
          on-timeout = "pidof hyprlock && hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 30;
          on-timeout = "pidof hyprlock && systemctl \"suspend\"";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 900;
          on-timeout = "pidof hyprlock || hyprlock";
        }
        {
          timeout = 920;
          on-timeout = "systemctl \"suspend\"";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 50;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 7;
        }
      ];
    };
  };

  services.awww.enable = true;

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "lua";
    extraLuaFiles = {
      generated = import ./hyprland.lua.nix {inherit pkgs lib;};
    };
  };
}
