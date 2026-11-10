{
  lib,
  pkgs,
  theme,
  ...
}: let
  catFlavor = lib.removePrefix "catppuccin-" theme.name; # "mocha", "latte", …
in {
  stylix = {
    enable = true;
    base16Scheme = theme.file;
    polarity = theme.scheme.variant; # "dark" | "light"

    # overlays recolor gtksourceview/nixos-icons, which busts the binary
    # cache for everything depending on them (inkscape, …) -> local rebuilds
    overlays.enable = false;

    image = theme.wallpaper;
    # match the pre-stylix look: stylix defaults (DejaVu, 12pt apps) enlarge GTK/zen
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sizes = {
        applications = 10; # GTK's default before; zen scales its UI from this
        popups = 14; # rofi/swaync
      };
    };
    cursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 25;
    };
    icons = {
      enable = true;
      # Accent-colored Papirus folders: exact mauve for Catppuccin schemes,
      # the closest stock papirus-folders color for everything else.
      package =
        if lib.hasPrefix "catppuccin-" theme.name
        then
          pkgs.catppuccin-papirus-folders.override {
            flavor = catFlavor;
            accent = "mauve";
          }
        else
          (pkgs.papirus-icon-theme.override {color = theme.folderColor or "violet";}).overrideAttrs {
            # these fixup steps crawl ~100k icons for nothing (minutes); full
            # dontFixup would also drop the propagated breeze-icons fallback
            dontPatchShebangs = true;
            dontCheckForBrokenSymlinks = true;
          };
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };
}
