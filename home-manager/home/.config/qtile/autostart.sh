#!/usr/bin/env sh

if [ "$XDG_SESSION_TYPE" == "x11" ]; then
  #set resolution and refresh rate
  if [ -x "$(command -v xrandr)" ]; then
    xrandr -s 2560x1080 -r 100
  fi

  #boot picom if it exists
  if [ -x "$(command -v picom)" ]; then
    picom &
  fi

  #set background
  if [ -x "$(command -v nitrogen)" ]; then
    nitrogen --restore &
  fi

  # sxhkd
  if [ -x "$(command -v sxhkd)" ]; then
    sxhkd &
  fi

  # enable numlock
  if [ -x "$(command -v numlockx)" ]; then
    numlockx on
  fi

elif [ "$XDG_SESSION_TYPE" == "wayland" ]; then
  # dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

  # wallpaper
  if [ -x "$(command -v swww)" ]; then
    swww init &
    wallpapers /mnt/DATA/Nextcloud/Wallpapers/Current/
  fi
fi

#start notification daemon
if [ -x "$(command -v dunst)" ]; then
  dunst &
fi

# #set night light
if [ -x "$(command -v gammastep-indicator)" ]; then
  gammastep-indicator &
fi

if [ -x "$(command -v nm-applet)" ]; then
  nm-applet --indicator &
fi

# bluetooth
if [ -x "$(command -v blueman-applet)" ]; then
  blueman-applet &
fi

# multilingual inputs
if [ -x "$(command -v fcitx5)" ]; then
  fcitx5 -d &
fi

systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service
