{inputs, ...}: {
  nix = {
    settings = {
      # Flakes.
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://lanzaboote.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
      ];
      trusted-users = ["root" "@wheel"];
      nix-path = ["nixpkgs=${inputs.nixpkgs}"];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
