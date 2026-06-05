{lib, ...}: {
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = ["jonasfeld"];

  virtualisation = {
    containers.enable = true;
    docker.enable = true;
  };

  # fix to get docker service off the critical boot path
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [];

  networking.firewall.trustedInterfaces = [
    "br+"
    "veth+"
    "docker0"
  ];
}
