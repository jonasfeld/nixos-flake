{ pkgs, config }:

let
  nm-connection-editor = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
in /* json */ '' {
  "layer": "top",
  "position": "top",

  "modules-left": [
    "hyprland/workspaces",
    "memory",
    "cpu",
    "temperature",
    "battery"
  ],

  "modules-center": [
    "hyprland/window"
  ],

  "modules-right": [
    "tray",
    "pulseaudio",
    "backlight",
    "network",
    "custom/notification",
    "clock"
  ],

  // Modules

  "hyprland/workspaces": {
    "disable-scroll": true,
    "on-click": "activate",
    "sort-by-number": true,
    "persistent-workspaces": {
      "*": 10
    }
  },

  "memory": {
    "interval": 15,
    "format": "Mem {percentage}%",
    "states": {
      "warning": 70,
      "critical": 90
    },
    "tooltip": true
  },

  "cpu": {
    "interval": 15,
    "tooltip": true,
    "format": "CPU {usage}%",
    "states": {
      "warning": 70,
      "critical": 90
    }
  },

  "temperature": {
    "thermal-zone": 2,
    "critical-threshold": 80,
    "interval": 15,
    "format": "Tmp {temperatureC}°",
    "tooltip": true
  },

  "battery": {
    "interval": 15,
    "states": {
      "warning": 30,
      "critical": 15
    },
    "format": "Bat {capacity}%",
    "format-charging": "Bat {capacity}%",
    "tooltip": true
  },
  
  "tray": {
    "icon-size": 15,
    "spacing": 5,
    "reverse-direction": true,
    "show-passive-items": true
  },

  "pulseaudio": {
    "format": "{volume}% {icon}  {format_source}",
    "format-bluetooth": "{icon} {volume}%  {format_source}",
    "format-muted": "{volume}%   {format_source}",
    "format-source": "{volume}% ",
    "format-source-muted": "{volume}% ",
    "format-icons": {
      "headphone": "",
      "hands-free": "",
      "headset": "",
      "phone": "",
      "portable": "",
      "car": "",
      "default": ["", "", ""]
    },
    "scroll-step": 1,
    "on-click": "${pavucontrol}",
    "tooltip": false
  },

  "backlight": {
    "device": "intel_backlight",
    "format": "{percent}% {icon}",
    "format-icons": ["", "", "", "", "", "", "", "", ""]
  },

  "network": {
    "interval": 15,
    "format-wifi": "{essid} ({signalStrength}%)",
    "format-ethernet": "{ifname}",
    "format-disconnected": "No connection",
    "tooltip": false,
    "on-click": "${nm-connection-editor}"
  },

  "clock": {
    "interval": 5,
    "format": "{:%a %d.%m. %H:%M}",
    "tooltip": false
  },

  "custom/notification": {
    "tooltip": false,
    "format": " {icon}",
    "format-icons": {
      "notification": "<span foreground='red'><small><sup>⬤</sup></small></span>",
      "none": " ",
      "dnd-notification": "<span foreground='red'><small><sup>⬤</sup></small></span>",
      "dnd-none": " "
    },
    "return-type": "json",
    "exec": "${swaync-client} -swb",
    "on-click": "sleep 0.1 && ${swaync-client} -t -sw",
    "on-click-right": "sleep 0.1 && ${swaync-client} -d -sw",
    "escape": true
  }
} ''
