{pkgs, ...}: {
  users.users.jonasfeld = {
    isNormalUser = true;
    description = "Jonas";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "adbusers"
      "syncthing"
    ];
    initialPassword = "password";
    shell = pkgs.zsh;
  };
}
