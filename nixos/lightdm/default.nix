{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.lightdm = {
      enable = true;
      background = ./background.png;

      greeters.gtk = {
        enable = true;
        cursorTheme.name = "Adwaita";
        iconTheme = {
          name = "Dracula";
          package = pkgs.dracula-icon-theme;
        };
        theme = {
          name = "Dracula";
          package = pkgs.dracula-theme;
        };
        indicators = [ "~session" "~power" ];
        extraConfig = ''
          hide-user-image = true
        '';
      };
  };
}
