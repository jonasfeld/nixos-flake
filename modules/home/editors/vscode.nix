{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      userSettings = {
        "catppuccin.accentColor" = "mauve";
        "editor.semanticHighlighting.enabled" = true;
        "terminal.integrated.minimumContrastRatio" = 1;
        "terminal.integrated.inheritEnv" = false;
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "window.titleBarStyle" = "custom";

        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "editor.lineNumbers" = "relative";

        "typescript.updateImportsOnFileMove.enabled" = "always";
        "typescript.preferences.importModuleSpecifier" = "relative";
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "workbench.colorCustomizations" = {
          "editorBracketHighlight.foreground1" = "#ffff00";
          "editorBracketHighlight.foreground2" = "#40ff00";
          "editorBracketHighlight.foreground3" = "#00ffff";
          "editorBracketHighlight.foreground4" = "#bf00ff";
          "editorBracketHighlight.foreground5" = "#ff00bf";
          "editorBracketHighlight.foreground6" = "#db6165";
          "editorBracketHighlight.unexpectedBracket.foreground" = "#ff0000";
        };

        "git.autofetch" = true;
        "git.confirmSync" = false;

        "vim.handleKeys" = {
          # "<C-a>"= false;
          "<C-f>" = false;
          "<C-b>" = false;
          "<C-p>" = false;
          "<C-n>" = false;
          "<C-k>" = false;
        };
        "workbench.secondarySideBar.defaultVisibility" = "hidden";
        "githubPullRequests.createOnPublishBranch" = "never";
        "redhat.telemetry.enabled" = false;
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "gitlens.launchpad.indicator.enabled" = false;
      };
      extensions = with pkgs.vscode-extensions; [
        # github.copilot
        github.vscode-pull-request-github
        vscodevim.vim
        catppuccin.catppuccin-vsc
        kamadorueda.alejandra
        eamodio.gitlens
        esbenp.prettier-vscode
        dart-code.flutter
        dart-code.dart-code
        tamasfe.even-better-toml
        ms-python.vscode-pylance
        ms-python.python
        prisma.prisma
        ms-vscode-remote.remote-ssh
        jnoortheen.nix-ide
        mkhl.direnv
      ];
    };
  };
}
