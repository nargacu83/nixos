{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs29-pgtk
  ];

  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  systemd.user.services.emacs.path = [ "$XDG_CONFIG_HOME/emacs/bin" ];
}
