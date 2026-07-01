{pkgs, ...}: {
  # system level packages
  environment.systemPackages = with pkgs; [
    cutecom
    serial-studio
  ];

  # enable wireshark
  # programs.wireshark.enable = true;
  # programs.wireshark.package = pkgs.wireshark;

  users.users.jonasfeld.extraGroups = [
    "dialout"
    "wireshark"
  ];
}
