{theme, ...}: let
  palette = builtins.mapAttrs (_: s: builtins.substring 1 6 s) theme.scheme.palette; # "#rrggbb" -> "rrggbb"
  rgb = col: "rgb(${col})";
  font = "JetBrainsMono Nerd Font";
  surface0 = palette.base02;
  text = palette.base05;
  accent = palette.base0E; # mauve in Catppuccin
  red = palette.base08;
  yellow = palette.base0A;
  label = attrs:
    {
      monitor = "";
      color = rgb text;
      font_family = font;
    }
    // attrs;
in {
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock.settings = {
    label = [
      (label {
        text = "Layout: $LAYOUT";
        font_size = 25;
        position = "30, -30";
        halign = "left";
        valign = "top";
      })
      (label {
        text = "$TIME";
        font_size = 90;
        position = "-30, 0";
        halign = "right";
        valign = "top";
      })
      (label {
        text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
        font_size = 25;
        position = "-30, -150";
        halign = "right";
        valign = "top";
      })
      (label {
        text = "$FPRINTPROMPT";
        font_size = 14;
        position = "0, -107";
        halign = "center";
        valign = "center";
      })
    ];
    image = [
      {
        monitor = "";
        path = "$HOME/.face";
        size = 100;
        border_color = rgb accent;
        position = "0, 75";
        halign = "center";
        valign = "center";
      }
    ];
    input-field = [
      {
        monitor = "";
        size = "300, 60";
        outline_thickness = 4;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = rgb accent;
        inner_color = rgb surface0;
        font_color = rgb text;
        fade_on_empty = false;
        placeholder_text = ''<span foreground="##${text}"><i>󰌾 Logged in as </i><span foreground="##${accent}">$USER</span></span>'';
        hide_input = false;
        check_color = rgb accent;
        fail_color = rgb red;
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = rgb yellow;
        position = "0, -47";
        halign = "center";
        valign = "center";
      }
    ];
  };
}
