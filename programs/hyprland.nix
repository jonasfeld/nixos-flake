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
    		${lock_cmd}
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
    convert -scale 10% -blur 0x2.5 -resize 1000% $LOCKFILE $LOCKFILE;
    swaylock --image $LOCKFILE
  '';
  display_off_when_lock = pkgs.writeShellScript "display_off_when_lock" ''
    swayidle -w \
      timeout 10 'if pgrep swaylock; then hyprctl dispatch dpms off; fi' \
      resume 'hyprctl dispatch dpms on' \
      timeout 60 'if pgrep swaylock; then systemctl "suspend"; fi' \
      after-resume 'hyprctl dispatch dpms on' \
  '';
  idle_lock = pkgs.writeShellScript "idle_lock" ''
    swayidle -w \
      timeout 900 'systemctl "suspend"' \
      before-sleep '${lock_cmd}'
  '';
  volume_brightness = import ../modules/soundkeys.nix pkgs;
in {
  home.packages = with pkgs; [
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
    swaynotificationcenter # notification bar
    swww # wallpapers
    brightnessctl # light control
    libnotify # sending notifications
    playerctl # controlling the multimedia player
    pulseaudio # audiocontrol
    grim # screenshots
    slurp # screenshots (selection)
    copyq # clipboard history
    hyprcursor
  ];

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
        "swww init && swww ${../nix-black-4k.png}"
        "${pkgs.swaynotificationcenter}/bin/swaync"
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
      ];

      misc = {
        focus_on_activate = true;
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
}
