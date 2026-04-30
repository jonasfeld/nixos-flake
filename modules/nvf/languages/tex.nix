{
  lib,
  pkgs,
  ...
}: {
  vim = {
    languages.tex.enable = true;
    lsp.servers.texlab = {
      settings = {
        texlab = {
          build = {
            args = ["-pdf" "-interaction=nonstopmode" "-synctex=1" "%f"];
            onSave = true;
            forwardSearchAfter = true;
          };
          forwardSearch = {
            executable = "sioyek"; # installed externally
            args = [
              "--execute-command"
              "toggle_synctex"
              "--inverse-search"
              "${lib.getExe pkgs.texlab} inverse-search -i \"%%1\" -l %%2"
              "--forward-search-file"
              "%f"
              "--forward-search-line"
              "%l"
              "%p"
            ];
          };
        };
      };
    };
  };
}
