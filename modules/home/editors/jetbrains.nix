{pkgs, ...}: {
  home.packages = with pkgs; [
    android-studio
    jetbrains.idea
  ];
}
