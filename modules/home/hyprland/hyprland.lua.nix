{
  pkgs,
  lib,
}: let
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
  edit_screenshot = pkgs.writeShellScript "edit_screenshot" ''
    if [[ $(wl-paste -l)  != "image/png" ]]
    then
      exit 1;
    fi
    wl-paste | satty --filename - --actions-on-enter save-to-file --copy-command wl-copy --disable-notifications --initial-tool rectangle --early-exit --output-filename $HOME/Pictures/Screenshots/$(date +%F-%H-%M-%S).png
  '';
  volume_brightness = import ./soundkeys.nix pkgs;
in
  /*
  lua
  */
  ''
    local mod          = "SUPER"
    local soundkeys    = "${volume_brightness}"
    local screenshot   = "${edit_screenshot}"
    local power_menu   = "${power_menu}"
    local swaync       = "${lib.getExe pkgs.swaynotificationcenter}"
    local swaync_client = swaync .. "-client"
    local toggle       = "${rofi_toggle}"


    --------------------
    ---- MONITORS ----
    --------------------

    hl.monitor({ output = "",          mode = "preferred",  position = "auto", scale = "auto"     })
    hl.monitor({ output = "eDP-1",     mode = "2256x1504",  position = "0x0",  scale = 1.566667   })
    hl.monitor({ output = "Unknown-1", mode = "2256x1504",  position = "0x0",  scale = 1.566667   })


    --------------------
    ---- AUTOSTART ----
    --------------------

    hl.on("hyprland.start", function()
        hl.exec_cmd("${lib.getExe pkgs.copyq}")
        hl.exec_cmd("${lib.getExe pkgs.waybar}")
        hl.exec_cmd("${lib.getExe pkgs.awww} img ${../../../assets/nix-black-4k.png}")
        hl.exec_cmd(swaync)
        hl.exec_cmd("nm-applet --indicator")
        hl.exec_cmd("blueman-applet")
    end)


    --------------------------
    ---- LOOK AND FEEL ----
    --------------------------

    hl.config({
        general = {
            border_size      = 1,
            col = {
                active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
                inactive_border = "rgba(595959aa)",
            },
            gaps_in          = 3,
            gaps_out         = 5,
            resize_on_border = true,
        },
        animations = {},
        input = {
            kb_layout  = "eurkey",
            kb_options = "caps:escape",
        },
        misc = {
            disable_hyprland_logo    = true,
            disable_splash_rendering = true,
            focus_on_activate        = true,
        },
        cursor = {
            hide_on_key_press = true,
        },
        xwayland = {
            force_zero_scaling = true,
        },
    })

    -- windows animation: enabled, speed 2, default bezier, popin 50%
    hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "default", style = "popin 50%" })


    --------------------
    ---- GESTURES ----
    --------------------

    hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })


    -------------------------
    ---- WORKSPACE RULES ----
    -------------------------

    hl.workspace_rule({ workspace = "1", default = true, monitor = "0" })
    for i = 2, 10 do
        hl.workspace_rule({ workspace = tostring(i), monitor = "0" })
    end
    hl.workspace_rule({ workspace = "11", default = true, monitor = "1" })
    for i = 12, 20 do
        hl.workspace_rule({ workspace = tostring(i), monitor = "1" })
    end
    hl.workspace_rule({ workspace = "21", default = true, monitor = "2" })
    for i = 22, 30 do
        hl.workspace_rule({ workspace = tostring(i), monitor = "2" })
    end


    ------------------------
    ---- WINDOW RULES ----
    ------------------------

    hl.window_rule({
        name  = "pavucontrol",
        match = { class = "org.pulseaudio.pavucontrol" },
        float = true,
        move  = "(monitor_w*0.75) 22",
        size  = "(monitor_w*.20) (monitor_h*0.50)",
    })

    hl.window_rule({
        name  = "blueman",
        match = { class = ".blueman-manager-wrapped" },
        float = true,
        move  = "(monitor_w*0.65) 22",
        size  = "(monitor_w*0.30) (monitor_h*0.50)",
    })

    hl.window_rule({
        name        = "float-no-border",
        match       = { float = true },
        border_size = 0,
    })


    -----------------------
    ---- KEYBINDINGS ----
    -----------------------

    -- Terminal
    hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty +new-window"))

    -- Window management
    hl.bind("ALT + space", hl.dsp.window.close())
    hl.bind("ALT + F4",    hl.dsp.window.close())
    hl.bind(mod .. " + B", hl.dsp.window.pseudo())
    hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

    -- Focus
    hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left"  }))
    hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up"    }))
    hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down"  }))

    -- Move windows
    hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left"  }))
    hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up"    }))
    hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down"  }))

    -- Workspace navigation
    hl.bind(mod .. " + TAB",         hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

    for i = 1, 10 do
        local key = tostring(i % 10)  -- 10 → key "0"
        hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = "r~" .. tostring(i) }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = "r~" .. tostring(i) }))
    end

    hl.bind(mod .. " + CTRL + SHIFT + H", hl.dsp.window.move({ workspace = "r-1" }))
    hl.bind(mod .. " + CTRL + SHIFT + L", hl.dsp.window.move({ workspace = "r+1" }))
    hl.bind(mod .. " + CTRL + H",         hl.dsp.focus({ workspace = "r-1" }))
    hl.bind(mod .. " + CTRL + L",         hl.dsp.focus({ workspace = "r+1" }))

    hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

    hl.bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "m+1" }))
    hl.bind("CTRL + ALT + left",  hl.dsp.focus({ workspace = "m-1" }))

    -- Audio (non-repeating)
    hl.bind("XF86AudioMute",  hl.dsp.exec_cmd(soundkeys .. " volume_mute"))
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd(soundkeys .. " play_pause"))
    hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(soundkeys .. " play_pause"))
    hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(soundkeys .. " prev_track"))
    hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(soundkeys .. " next_track"))

    -- Audio + brightness (repeating)
    hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(soundkeys .. " volume_down"),    { repeating = true })
    hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(soundkeys .. " volume_up"),      { repeating = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(soundkeys .. " brightness_up"),  { repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(soundkeys .. " brightness_down"),{ repeating = true })

    -- Resize active window (repeating)
    hl.bind("CTRL + ALT + L", hl.dsp.window.resize({ x =  40, y =   0 }), { repeating = true })
    hl.bind("CTRL + ALT + H", hl.dsp.window.resize({ x = -40, y =   0 }), { repeating = true })
    hl.bind("CTRL + ALT + K", hl.dsp.window.resize({ x =   0, y = -40 }), { repeating = true })
    hl.bind("CTRL + ALT + J", hl.dsp.window.resize({ x =   0, y =  40 }), { repeating = true })

    -- Lock screen
    hl.bind(mod .. " + CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))
    hl.bind("CTRL + ALT + Q",           hl.dsp.exec_cmd("hyprlock"))

    -- Screenshots
    hl.bind("Print",           hl.dsp.exec_cmd("grimblast --freeze copy area"))
    hl.bind(mod .. " + Print", hl.dsp.exec_cmd(screenshot))
    hl.bind(mod .. " + F11",   hl.dsp.exec_cmd(screenshot))
    hl.bind("CTRL + Print",    hl.dsp.exec_cmd(
        "grimblast save output - | satty --filename - --actions-on-enter save-to-file" ..
        " --copy-command wl-copy --disable-notifications --initial-tool rectangle" ..
        " --early-exit --output-filename $HOME/Pictures/Screenshots/$(date +%F-%H-%M-%S).png"
    ))

    -- Power menu and notifications
    hl.bind(mod .. " + ESCAPE", hl.dsp.exec_cmd(power_menu .. ' "rofi -dmenu -p Power"'))
    hl.bind(mod .. " + n",      hl.dsp.exec_cmd(swaync_client .. " -t -sw"))

    -- App launcher toggle (on key release)
    hl.bind(mod .. " + Super_L", hl.dsp.exec_cmd(toggle), { release = true })
  ''
