{ config, lib, pkgs, ... }:

{
  services.flatpak.enable = true;
  environment.sessionVariables = {
    # To fix cursor theme not applying to some Flatpak: flatpak override --user --filesystem=/nix/store:ro
    XDG_DATA_DIRS = [
      "/var/lib/flatpak/exports/share"
      "/home/quentin/.local/share/flatpak/exports/share"
    ];
  };
}
