{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    wineWowPackages.stagingFull
    winetricks
  ];
}
