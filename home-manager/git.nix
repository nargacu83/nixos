{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName  = "Quentin Franchi";
    userEmail = "dev.quentinfranchi@protonmail.com";
    signing = {
      signByDefault = true;
      key = "D83F9668BF7DDC45";
    };
  };
}
