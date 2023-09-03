{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    wineWowPackages.stagingFull
    winetricks
    protonup-qt
  ];
}
