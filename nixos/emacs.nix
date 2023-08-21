{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    binutils
    gnutls

    emacs-gtk
    emacsPackages.vterm
    ripgrep
    fd

    # in-emacs gnupg prompts
    pinentry_emacs
    zstd
  ];

  systemd.user.services.emacs.path = [ "$XDG_CONFIG_HOME/emacs/bin" ];
}
