_: {
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
            args = ["--forward-search-file" "%p" "--forward-search-line" "%l"];
          };
        };
      };
    };
  };
}
