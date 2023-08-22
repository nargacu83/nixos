{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # wine-staging (version with experimental features)
    wineWowPackages.stagingFull
    wine64Packages.stagingFull
    # native wayland support (unstable)
    # wineWowPackages.waylandFull

    winetricks
  ];
}
