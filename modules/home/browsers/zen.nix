{inputs, ...}: {
  stylix.targets.zen-browser.profileNames = ["default"];

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    # Betterfox for Zen (yokoffing/Betterfox zen/user.js, aka BetterZen):
    # privacy/telemetry/performance prefs applied as mkDefault settings —
    # any profile `settings` entry wins.
    profiles.default.presets.betterfox.enable = true;
  };
}
