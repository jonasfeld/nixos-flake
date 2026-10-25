{
  services.displayManager.dux-greeter = {
    enable = true;
    compositor = {
      name = "hyprland";
      customConfig =
        /*
        lua
        */
        ''
          --------------------
          ---- MONITORS ----
          --------------------

          hl.monitor({ output = "",          mode = "preferred",  position = "auto", scale = "auto"     })
          hl.monitor({ output = "eDP-1",     mode = "2256x1504",  position = "0x0",  scale = 1.566667   })
          hl.monitor({ output = "Unknown-1", mode = "2256x1504",  position = "0x0",  scale = 1.566667   })
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
              invisible = true,
            },
            xwayland = {
              force_zero_scaling = true,
            },
          })
        '';
    };
  };

  security.pam.services.greetd = {
    enableGnomeKeyring = true;
    fprintAuth = false;
  };
}
