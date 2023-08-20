#!/usr/bin/env sh
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# wallpaper
if [ -x "$(command -v swww)" ]; then
  swww init &
  wallpapers /mnt/DATA/Nextcloud/Wallpapers/Current/
fi

#start notification daemon
if [ -x "$(command -v dunst)" ]; then
  dunst &
fi

# bar
if [ -x "$(command -v waybar)" ]; then
  waybar &
fi

if [ -x "$(command -v gammastep-indicator)" ]; then
  gammastep-indicator -m wayland &
fi

if [ -x "$(command -v nautilus)" ]; then
  nautilus --gapplication-service &
fi

if [ -x "$(command -v nm-applet)" ]; then
  nm-applet --indicator &
fi

# # bluetooth TODO: Find alternative that support Wayland.
# if [ -x "$(command -v blueman-applet)" ]; then
#   blueman-applet &
# fi
#
if [ -x "$(command -v emacs)" ]; then
  systemctl --user is-active --quiet emacs || systemctl --user restart emacs
fi

if [ -x "$(command -v easyeffects)" ]; then
  systemctl --user is-active --quiet easyeffects || systemctl --user restart easyeffects
fi

# multilingual inputs
if [ -x "$(command -v fcitx5)" ]; then
  fcitx5 -d &
fi

# Atomic
sleep 1
killall xdg-desktop-portal-gtk
killall xdg-desktop-portal-kde
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/libexec/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
