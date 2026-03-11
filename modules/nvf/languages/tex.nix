{pkgs, ...}: {
  vim = {
    lsp.servers.texlab = {
      enable = true;
      cmd = ["${pkgs.texlab}/bin/texlab" "-v"];
      filetypes = ["tex" "bib"];
      root_markers = [".latexmkrc"];
      settings = {
        texlab = {
          build = {
            args = ["-pdf" "-interaction=nonstopmode" "-synctex=1" "%f"];
            onSave = true;
            forwardSearchAfter = true;
          };
          forwardSearch = {
            executable = "sioyek"; # installed externally
            args = ["--forward-search-file %p" "--forward-search-line %l"];
          };
          cktex.onOpenAndSave = true;
          latexFormatter = "tex-fmt"; # installed externally
        };
      };
    };
  };
}
