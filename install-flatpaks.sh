#!/usr/bin/env sh

flatpacks=(
   "com.github.tchx84.Flatseal"
   "org.gtk.Gtk3theme.adw-gtk3-dark"
   "io.freetubeapp.FreeTube"

   "info.beyondallreason.bar"
   "com.valvesoftware.Steam"
   "org.freedesktop.Platform.VulkanLayer.gamescope"

   "org.godotengine.Godot"
   "io.github.achetagames.epic_asset_manager"

   "com.discordapp.Discord"
)

gtk_theme="adw-gtk3-dark"

# Flatpaks to apply the theme
flatpacks_theme=(
   "io.freetubeapp.FreeTube"
   "info.beyondallreason.bar"
   "com.valvesoftware.Steam"
   "org.godotengine.Godot"
   "com.discordapp.Discord"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
# Styles
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

function print_message() {
    echo -e "${BOLD}${GREEN} ==> ${NC} ${BOLD}${1}${NORMAL}"
}

function print_inner_message() {
    echo -e "${BOLD}${BLUE} ->${NC} ${BOLD}${1}${NORMAL}"
}

function print_error() {
    echo -e "${BOLD}${RED} ->${NC} ${BOLD}${1}${NORMAL}"
    exit 1
}

print_message "Installing Flatpaks..."
for flatpak in "${flatpaks[@]}"; do
    flatpak install -y $flatpak || print_error "Could not install flatpak: $flatpak"
done

print_message "Configuring Flatpaks..."
flatpak --user override --reset

# Fixes for fonts and icons
ln -s /run/current-system/sw/share/X11/fonts ~/.local/share/fonts
flatpak --user override --filesystem=$HOME/.local/share/fonts:ro
flatpak --user override --filesystem=$HOME/.icons/:ro
flatpak --user override --filesystem=/usr/share/icons/:ro
flatpak --user override --filesystem=/nix/store:ro

## Only for Discord
flatpak --user override --unset-env=XCURSOR_PATH
##

print_message "Applying theme..."
for flatpak in "${flatpacks_theme[@]}"; do
    flatpak --user override --env=GTK_THEME=$gtk_theme $flatpak
done

print_message "Flatpaks installed and configured."
