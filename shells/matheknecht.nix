{pkgs ? import <nixpkgs> {}}:
with pkgs;
mkShell {
  buildInputs = [
      (python3.withPackages (pypkg: with pypkg; [ ipython numpy matplotlib jupyter ]))
      calc
  ];
}
