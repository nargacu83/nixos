{ config, lib, pkgs, ... }:

{
  # services.emacs = {
  #   enable = true;
  #   package = pkgs.emacs-pgtk;
  # };

  home.packages = with pkgs; [
    binutils
    gnutls

    emacsPackages.vterm
    ripgrep
    fd

    # in-emacs gnupg prompts
    pinentry_emacs
    zstd
  ];

  # systemd.user.services.emacs.path = [ "$XDG_CONFIG_HOME/emacs/bin" ];
}
