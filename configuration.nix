# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-b350adf5-976c-4a6e-8500-2cc84d73e24d".device = "/dev/disk/by-uuid/b350adf5-976c-4a6e-8500-2cc84d73e24d";
  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "JetBrainsMono"
      ];
    })
    font-awesome
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

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
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonasfeld = {
    isNormalUser = true;
    description = "Jonas";
    extraGroups = ["networkmanager" "wheel" "docker"];
    initialPassword = "password";
    packages = with pkgs; [
      firefox
      thunderbird
      spotify
      keepass
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
    htop
    zsh
    fprintd
    usbutils
    ripgrep

    # paperwm for use in gnome
    gnomeExtensions.paperwm
    gnome.gnome-tweaks
    gnome-extension-manager

    qemu
    quickemu
  ];

  # Setup zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  security.polkit.enable = true;
  security.pam.services.swaylock.text = "auth include login";

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # Services
  virtualisation.docker.enable = true;

  programs.ssh.startAgent = true;
  services = {
    blueman.enable = true;
    fprintd.enable = true;
    fprintd.tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix-550a;
    };

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
      #      # Enable the X11 windowing system.
      enable = true;
      #
      #      # Keyboard
      xkb.layout = "us";
      xkb.variant = "";
      #
      #      # GNOME
      displayManager.gdm.enable = true;
      # desktopManager.gnome.enable = true;
      #      # windowManager.i3 = {
      #      #   enable = true;
      #      # };
    };

    # Enable CUPS to print documents.
    printing.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
