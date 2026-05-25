_: {
  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    XCURSOR_SIZE = "25";
    QT_CURSOR_SIZE = "25";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
    # QT_SCALE_FACTOR = "1.566667";
    GDK_SCALE = "1.566667";
  };

  # Hyprland
  programs.hyprland.enable = true;
  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "eurkey";
      xkb.extraLayouts.eurkey = {
        description = "EurKEY layout - https://eurkey.steffen.bruentjen.eu";
        languages = ["eng"];
        symbolsFile = ../../../assets/keyboard_eurkey-1.2;
      };
    };
    displayManager.gdm.enable = true;
  };

  security = {
    pam.services = {
      login.fprintAuth = false;
      login.enableGnomeKeyring = true;
      sudo.fprintAuth = false;
      gdm-fingerprint = {
        enableGnomeKeyring = true;
        startSession = true;
        fprintAuth = true;
      };
      hyprlock.text = "auth include login";
    };
    polkit.enable = true;
    # for enrolling fprints
    # polkit.extraConfig = ''
    #   polkit.addRule(function(action, subject) {
    #       if (action.id === "net.reactivated.fprint.device.enroll") {
    #           return polkit.Result.YES;
    #       }
    #   });
    # '';
  };
}
