# Main settings for the "nixos" laptop host
{
  pkgs,
  special-pkgs,
  lib,
  inputs,
  lanzaboote,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    lanzaboote.nixosModules.lanzaboote
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  environment.systemPackages = with pkgs; [
    # secure boot
    sbctl
  ];

  # we need the new kernel, right? :)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # luks
  boot.initrd.luks.devices."luks-b350adf5-976c-4a6e-8500-2cc84d73e24d".device = "/dev/disk/by-uuid/b350adf5-976c-4a6e-8500-2cc84d73e24d";
  networking.hostName = "nixos"; # Define your hostname.

  security.rtkit.enable = true; # required for pipewire

  services = {
    # bluetooth
    blueman.enable = true;

    # firmware updates
    fwupd.enable = true;

    # power daemon
    upower.enable = true;

    # sound with pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pulseaudio.enable = false; # disable for pipewire

    # fingerprint
    fprintd.enable = true;

    # CUPS to print documents
    printing = {
      enable = true;
      drivers = with pkgs; [gutenprint hplip splix];
    };
  };

  hardware.bluetooth.enable = true;

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
