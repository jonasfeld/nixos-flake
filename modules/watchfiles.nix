pkgs:
pkgs.writeShellScriptBin "wt" ''
  function execute() {
    eval "''\${2}"
  }
  ${pkgs.inotify-tools}/bin/inotifywait --monitor --recursive --include $1 \
    --format "%e %w%f" --event modify,move,create,delete ./ \
    | while read changed; do
      execute "''\$@"
    done
''
