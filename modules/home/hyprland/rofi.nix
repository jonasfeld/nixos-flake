{
  pkgs,
  theme,
  ...
}: {
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    settings = {
      terminal = "ghostty";
      modi = "combi";
      combi-modi = "window,drun";
      icon-theme = "Oranchelo";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      window-format = "{icon} {title}";
      location = 0;
      disable-history = false;
      display-combi = "  Apps";
      display-drun = " ";
      display-window = " ";
      sidebar-mode = true;
    };
    theme = with theme.scheme.palette; "${pkgs.writeText "theme.rasi" ''
      * {
          bg-col:  ${base00};
          bg-col-light: ${base00};
          border-col: ${base00};
          selected-col: ${base00};
          blue: ${base0D};
          fg-col: ${base05};
          fg-col2: ${base08};
          grey: ${base04};
          teal: ${base0C};
          width: 800;
          border-radius: 15px;
          font: "JetBrainsMono Nerd Font 14";
      }

      element-text, element-icon, mode-switcher {
          background-color: inherit;
          text-color:       inherit;
      }

      window {
          height: 360px;
          border: 2px;
          border-color: @teal;
          background-color: @bg-col;
      }

      mainbox {
          background-color: @bg-col;
      }

      inputbar {
          children: [prompt,entry];
          background-color: @bg-col;
          border-radius: 5px;
          padding: 2px;
      }

      prompt {
          background-color: @blue;
          padding: 6px;
          text-color: @bg-col;
          border-radius: 3px;
          margin: 20px 0px 0px 20px;
      }

      textbox-prompt-colon {
          expand: false;
          str: ":";
      }

      entry {
          padding: 6px;
          margin: 20px 0px 0px 10px;
          text-color: @fg-col;
          background-color: @bg-col;
      }

      listview {
          border: 0px 0px 0px;
          padding: 6px 0px 0px;
          margin: 10px 0px 0px 20px;
          columns: 2;
          lines: 5;
          background-color: @bg-col;
      }

      element {
          padding: 5px;
          background-color: @bg-col;
          text-color: @fg-col;
      }

      element-icon {
          size: 25px;
      }

      element selected {
          background-color: @selected-col ;
          text-color: @teal;
      }

      mode-switcher {
          spacing: 0;
      }

      button {
          padding: 10px;
          background-color: @bg-col-light;
          text-color: @grey;
          vertical-align: 0.5;
          horizontal-align: 0.5;
      }

      button selected {
        background-color: @bg-col;
        text-color: @blue;
      }

      message {
          background-color: @bg-col-light;
          margin: 2px;
          padding: 2px;
          border-radius: 5px;
      }

      textbox {
          padding: 6px;
          margin: 20px 0px 0px 20px;
          text-color: @blue;
          background-color: @bg-col-light;
      }
    ''}";
  };
}
