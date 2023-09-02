#!/usr/bin/env sh

resolution="2560x1080"
refresh_rate="100"

# launch the given program in the background only if an instance isn't already running
function launch_once() {
  ps x | grep -v grep | grep ${1} &>/dev/null || ${1} &
}

if [ "$XDG_SESSION_TYPE" == "x11" ]; then
  #set resolution and refresh rate
  if [ -x "$(command -v xrandr)" ]; then
    xrandr -s ${resolution} -r ${refresh_rate}
  fi

  #boot picom if it exists
  if [ -x "$(command -v picom)" ]; then
    picom --daemon
  fi

  # sxhkd
  if [ -x "$(command -v sxhkd)" ]; then
    launch_once sxhkd
  fi

  # enable numlock
  if [ -x "$(command -v numlockx)" ]; then
    numlockx on
  fi

  #set background
  if [ -x "$(command -v nitrogen)" ]; then
    nitrogen --restore &
  fi

  # bluetooth
  if [ -x "$(command -v blueman-applet)" ]; then
    blueman-applet &
  fi

  # #set night light
  if [ -x "$(command -v gammastep-indicator)" ]; then
    launch_once gammastep-indicator
  fi

elif [ "$XDG_SESSION_TYPE" == "wayland" ]; then
  QT_QPA_PLATFORM=qt5ct;wayland;xcb
  GDK_BACKEND=wayland

  # Fix polkit not starting in wayland
  exec $(echo $(nix eval nixpkgs#polkit_gnome.outPath)/libexec/polkit-gnome-authentication-agent-1 | sed 's/"//g' &) &

  # Hyprland specific
  if [ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]; then
    XDG_CURRENT_DESKTOP=Hyprland
    XDG_SESSION_TYPE=wayland
    XDG_SESSION_DESKTOP=Hyprland
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

    hyprctl setcursor $XCURSOR_THEME $XCURSOR_SIZE

    if [ -x "$(command -v waybar)" ]; then
      waybar &
    fi
  fi

  # wallpaper
  if [ -x "$(command -v swww)" ]; then
    swww init &
    wallpapers /mnt/DATA/Nextcloud/Wallpapers/Current/
  fi


  # #set night light
  if [ -x "$(command -v gammastep-indicator)" ]; then
    gammastep-indicator -m wayland &
  fi
fi

#start notification daemon
if [ -x "$(command -v dunst)" ]; then
  dunst &
fi

# Network manager GUI
if [ -x "$(command -v nm-applet)" ]; then
  nm-applet --indicator &
fi

# multilingual inputs
if [ -x "$(command -v fcitx5)" ]; then
  fcitx5 -d &
fi

# Fixes xdg-open calls not opening links
systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service
