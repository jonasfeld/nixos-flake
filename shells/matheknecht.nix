{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    buildInputs = [
      python312Packages.ipython
      python312Packages.numpy
      python312Packages.matplotlib
    ];
  }
