{pkgs, ...}: {
  home.packages = [pkgs.handy pkgs.wtype];
  wayland.windowManager.hyprland.extraLuaFiles = {
    "stt" = {
      content =
        pkgs.writeText "stt-hyprland-bind.lua"
        /*
        lua
        */
        ''
          hl.bind("SUPER + O", hl.dsp.exec_cmd("handy --toggle-transcription"))
        '';
      autoLoad = true;
    };
  };
}
