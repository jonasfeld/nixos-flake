_: {
  vim = {
    lsp.servers.clangd = {
      root_markers = ["compile_commands.json" "CMakeLists.txt"];
    };

    languages.clang.enable = true;
  };
}
