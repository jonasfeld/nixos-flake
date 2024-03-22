pkgs: pkgs.writeShellScript "soundkeys" (builtins.readFile ./script.sh)
