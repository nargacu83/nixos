#!/usr/bin/env sh

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

#start notification daemon
if [ -x "$(command -v dunst)" ]; then
  dunst &
fi

# sxhkd
if [ -x "$(command -v sxhkd)" ]; then
  sxhkd &
fi

# enable numlock
if [ -x "$(command -v numlockx)" ]; then
  numlockx on
fi

# #set night light
if [ -x "$(command -v gammastep-indicator)" ]; then
  gammastep-indicator &
fi

if [ -x "$(command -v nautilus)" ]; then
  nautilus --gapplication-service &
fi

if [ -x "$(command -v nm-applet)" ]; then
  nm-applet &
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
