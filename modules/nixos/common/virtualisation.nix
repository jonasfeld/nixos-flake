_: {
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = ["jonasfeld"];

  virtualisation = {
    containers.enable = true;
    docker.enable = true;
  };

  networking.firewall.trustedInterfaces = [
    "br+"
    "veth+"
    "docker0"
  ];
}
