#!/usr/bin/env sh

FLATPAKS=(
   "com.github.tchx84.Flatseal"
   "org.gtk.Gtk3theme.adw-gtk3-dark"
   "io.freetubeapp.FreeTube"
   "com.obsproject.Studio"

   "info.beyondallreason.bar"
   "com.valvesoftware.Steam"
   "org.freedesktop.Platform.VulkanLayer.gamescope"

   "org.godotengine.Godot"
   "com.unity.UnityHub"
   "io.github.achetagames.epic_asset_manager"

   "com.discordapp.Discord"
)

function print_message() {
    echo -e "${BOLD}${2} ==> ${NC} ${BOLD}${1}${NORMAL}"
}

function print_inner_message() {
    echo -e "${BOLD}${BLUE} ->${NC} ${BOLD}${1}${NORMAL}"
}

function print_error() {
    echo -e "${BOLD}${RED} ->${NC} ${BOLD}${1}${NORMAL}"
    exit 1
}

print_message "Installing Flatpaks..."
for flatpak in "${FLATPAKS[@]}"; do
    flatpak install -y $flatpak || print_error "Could not install flatpak: $flatpak"
done

print_message "Configuring Flatpaks..."
flatpak --user override --filesystem=/home/$USER/.icons/:ro
flatpak --user override --filesystem=/usr/share/icons/:ro
flatpak --user override --filesystem=/nix/store:ro

