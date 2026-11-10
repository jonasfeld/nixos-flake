{theme, ...}: let
  palette = builtins.mapAttrs (_: s: builtins.substring 1 6 s) theme.scheme.palette; # "#rrggbb" -> "rrggbb"
in {
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
                active_border   = { colors = { "rgba(${palette.base0D}ee)", "rgba(${palette.base0E}ee)" }, angle = 45 },
                inactive_border = "rgba(${palette.base03}aa)",
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
