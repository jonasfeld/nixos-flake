{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    buildInputs = [
      python311Packages.ipython
      python311Packages.numpy
      python311Packages.matplotlib
      python311Packages.jupyter
    ];
  }
