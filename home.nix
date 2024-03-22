{pkgs, ...}: let
  dev_pkgs = with pkgs; [
    gh
    android-studio
  ];
  hyprland_pkgs = with pkgs; [
    rofi-wayland
    waybar
    pavucontrol
    swaylock
    swayidle
    dunst
    brightnessctl
    playerctl
    swww
  ];
  rofi_toggle = pkgs.writeShellScript "toggle" ''
    if (pidof rofi)
        then
            pkill rofi
        else
            rofi -show combi
        fi
  '';
in {
  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "waybar"
        # TODO wallpapers
        "swww init"
        "dunst"
      ];

      monitor = [
        ",preferred,auto,auto"
        "eDP-1,2256x1504,0x0,1.566667"
      ];

      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "ALT, space, killactive"
        "ALT, F4, killactive"
        "CONTROL, Space, togglefloating"
        "$mod, B, pseudo"
        "ALT, J, togglesplit"
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

        # Scroll through existing workspaces with mainMod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # next workspace on monitor
        "CONTROL_ALT, right, workspace, m+1"
        "CONTROL_ALT, left, workspace, m-1"

        # fn buttons
        ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86AudioPlay,         exec, playerctl play-pause"
        ",XF86AudioPrev,         exec, playerctl previous"
        ",XF86AudioNext,         exec, playerctl next"

        # lock
        "$mod CONTROL_ALT, L, exec, swaylock"
      ];

      binde = [
        # fn buttons
        ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86MonBrightnessUp,   exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"

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
        workspace_swipe_invert = false;
        workspace_swipe_cancel_ratio = 0.1;
      };
    };
  };

  home.username = "jonasfeld";
  home.homeDirectory = "/home/jonasfeld";

  home.packages = with pkgs;
    [
      cargo
      rustc
      zsh
      zoxide
      vscodium
      beekeeper-studio
      anki-bin

      # messengers
      signal-desktop
      whatsapp-for-linux
      element-desktop
      telegram-desktop

      # work related
      google-chrome
      slack

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
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
    };

    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
        vim = "nvim";
        edithome = "nvim ~/nixos/home.nix";
        editflake = "nvim ~/nixos/flake.nix";
        editconf = "nvim ~/nixos/configuration.nix";
        update = "nix flake update ~/nixos";
        upgrade = "update && rebuild";
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

  home.stateVersion = "23.11"; # do not change - or suffer the consequences
}
