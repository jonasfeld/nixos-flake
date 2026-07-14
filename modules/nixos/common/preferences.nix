{
  pkgs,
  special-pkgs,
  ...
}: {
  # time zone
  # services.automatic-timezoned.enable = true; # does not work for now
  time.timeZone = "Europe/Berlin";
  # time.timeZone = "Asia/Tokyo";

  # intl
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

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    font-awesome
    dm-sans
    liberation_ttf
    montserrat
  ];

  # zsh as default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # networking
  networking.networkmanager.enable = true;
  # networking.nftables.enable = true; # does not work because docker is dockering
  networking.firewall.enable = true;
  services.syncthing.openDefaultPorts = true;

  # always installed packages
  environment.systemPackages = with pkgs; [
    special-pkgs.nvim
    git
    tmux
    ghostty
    wget
    gcc
    zsh
    usbutils
    ripgrep
    btop
    man-pages

    # network debugging
    dig
    traceroute
    wireguard-tools
  ];

  programs.nix-ld.enable = true;
}
