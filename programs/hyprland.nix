{pkgs, ...}: let
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
    poweroff
    reboot
    suspend
    exit
    EOF`

    case $CHOICE in
    	suspend)
    		systemctl "suspend"
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
  volume_brightness = import ../modules/soundkeys.nix pkgs;
in {
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
    swww # wallpapers
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

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      input = {
        kb_layout = "eurkey";
        kb_options = "caps:escape";
      };

      exec-once = [
        "${pkgs.copyq}/bin/copyq"
        "waybar"
        "swww-daemon --no-cache & sleep 0.01 && swww img ${../assets/nix-black-4k.png}"
        "${pkgs.swaynotificationcenter}/bin/swaync"
        "nm-applet --indicator"
        "blueman-applet"
      ];

      xwayland.force_zero_scaling = true;

      windowrule = [
        "match:class org.pulseaudio.pavucontrol, float on, move (monitor_w*0.75) 22, size (monitor_w*.20) (monitor_h*0.50)"
        "match:class .blueman-manager-wrapped, float on, move (monitor_w*0.65) 22, size (monitor_w*0.30) (monitor_h*0.50)"
        "match:float true, border_size 0"
      ];

      misc = {
        focus_on_activate = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      monitor = [
        ",preferred,auto,auto"
        "eDP-1,2256x1504,0x0,1.566667"
        "Unknown-1,2256x1504,0x0,1.566667"
      ];

      "$mod" = "SUPER";

      gesture = "3, horizontal, workspace";

      workspace = builtins.concatLists (
        builtins.genList (
          monId: let
            baseWs = monId * 10 + 1; # base workspace number skip all the (% 10) = 1 workspaces to work around
            # hyprlands stupid default workspace for monitor selector
          in
            # ["${toString baseWs},monitor:${toString monId},default:true"] # die default selection funktioniert nicht mit monitor: id
            builtins.genList (offset: "${toString (baseWs + offset)},monitor:${toString monId}") 10
        )
        3
      );

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
        "$mod, 1, workspace, r~1"
        "$mod, 2, workspace, r~2"
        "$mod, 3, workspace, r~3"
        "$mod, 4, workspace, r~4"
        "$mod, 5, workspace, r~5"
        "$mod, 6, workspace, r~6"
        "$mod, 7, workspace, r~7"
        "$mod, 8, workspace, r~8"
        "$mod, 9, workspace, r~9"
        "$mod, 0, workspace, r~10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, r~1"
        "$mod SHIFT, 2, movetoworkspace, r~2"
        "$mod SHIFT, 3, movetoworkspace, r~3"
        "$mod SHIFT, 4, movetoworkspace, r~4"
        "$mod SHIFT, 5, movetoworkspace, r~5"
        "$mod SHIFT, 6, movetoworkspace, r~6"
        "$mod SHIFT, 7, movetoworkspace, r~7"
        "$mod SHIFT, 8, movetoworkspace, r~8"
        "$mod SHIFT, 9, movetoworkspace, r~9"
        "$mod SHIFT, 0, movetoworkspace, r~10"

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
        ",XF86AudioPause,         exec, ${volume_brightness} play_pause"
        ",XF86AudioPlay,         exec, ${volume_brightness} play_pause"
        ",XF86AudioPrev,         exec, ${volume_brightness} prev_track"
        ",XF86AudioNext,         exec, ${volume_brightness} next_track"

        # lock
        "$mod CONTROL_ALT, L, exec, hyprlock"

        # screenshot
        ", Print, exec, grimblast --freeze save area - | satty --filename - --actions-on-enter save-to-file --copy-command wl-copy --disable-notifications --initial-tool rectangle --early-exit --output-filename $HOME/Pictures/Screenshots/$(date +%F-%H-%M-%S).png"
        "CONTROL, Print, exec, grimblast save output - | satty --filename - --actions-on-enter save-to-file --copy-command wl-copy --disable-notifications --initial-tool rectangle --early-exit --output-filename $HOME/Pictures/Screenshots/$(date +%F-%H-%M-%S).png"

        # power menu
        "$mod, ESCAPE, exec, ${power_menu} \"rofi -dmenu -p Power\""

        # notification center
        "$mod, n, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
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
      animation = [
        "windows, 1, 2, default, popin 50%"
      ];

      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 1;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # no_border_on_floating = true;
        resize_on_border = true;
      };
    };
  };
}
