{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # wine-staging (version with experimental features)
    wineWowPackages.stagingFull

    # native wayland support (unstable)
    # wineWowPackages.waylandFull

    winetricks
  ];
}
