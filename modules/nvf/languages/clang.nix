_: {
  vim = {
    lsp.servers.clangd = {
      root_markers = ["compile_commands.json" "CMakeLists.txt"];
    };

    languages.clang = {
      extraDiagnostics.enable = false; # cpplint is currently broken 2026-07-14
      enable = true;
    };
  };
}
