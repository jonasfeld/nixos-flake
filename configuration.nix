# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  lanzaboote,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    lanzaboote.nixosModules.lanzaboote
  ];

  # Flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # we need the new kernel, right? :)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-b350adf5-976c-4a6e-8500-2cc84d73e24d".device = "/dev/disk/by-uuid/b350adf5-976c-4a6e-8500-2cc84d73e24d";
  networking.hostName = "nixos"; # Define your hostname.

  # Setup zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.networkmanager.dns = "none";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    font-awesome
    dm-sans
    liberation_ttf
  ];

  # Set your time zone.
  # services.automatic-timezoned.enable = true; # does not work for now
  time.timeZone = "Asia/Tokyo"; # "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonasfeld = {
    isNormalUser = true;
    description = "Jonas";
    extraGroups = ["networkmanager" "wheel" "docker" "adbusers" "kvm" "wireshark"];
    initialPassword = "password";
    packages = with pkgs; [
      firefox
      thunderbird
      spotify
      keepassxc
      onedrive
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    git
    tmux
    kitty
    wget
    gcc
    zsh
    usbutils
    ripgrep
    btop
    # gnome.seahorse

    # paperwm for use in gnome
    # gnomeExtensions.paperwm
    # gnome.gnome-tweaks
    # gnome-extension-manager

    # qemu
    # quickemu
    man-pages

    sbctl
  ];

  # enable adb
  programs.adb.enable = true;

  # enable wireshark
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # Hyprland
  programs.hyprland.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland; # bleeding edge

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };


  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
  };

  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    GDK_SCALE = "1";
    XCURSOR_SIZE = "20";
    QT_CURSOR_SIZE = "20";
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh"; # hacky. this should be set by gnome-keyring
    QT_AUTO_SCREEN_SCALE_FACTOR = "auto";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Services
  virtualisation.docker.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    fprintd.enable = true;
    upower.enable = true;

    # firmware updates
    fwupd.enable = true;

    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    xserver = {
      enable = true;
      xkb.layout = "eurkey";
      xkb.extraLayouts.eurkey = {
        description = "EurKEY layout - https://eurkey.steffen.bruentjen.eu";
        languages = ["eng"];
        symbolsFile = ./keyboard_eurkey-1.2;
      };
      displayManager.gdm.enable = true;
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint hplip splix ];
    };
  };

  security = {
    pam.services = {
      login.fprintAuth = false;
      login.enableGnomeKeyring = true;
      gdm-fingerprint = {
        enableGnomeKeyring = true;
        startSession = true;
        fprintAuth = true;
      };
      swaylock.text = "auth include login";
    };
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (action.id === "net.reactivated.fprint.device.enroll") {
                return polkit.Result.YES;
            }
        });
      '';
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [25565];
  };

  # Hyprland dependency cache
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
