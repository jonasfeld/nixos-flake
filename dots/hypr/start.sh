#!/usr/bin/env bash

# Init wallpaper daemon
swww init &

swww img ~/Pictures/Wallhaven/wallhaven-pk2kq3-sad-rain-umbrella.png &

nm-applet --indicator &

waybar &

dunst
