{ config, lib, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  home.packages = with pkgs; [
    binutils
    gnutls
    ripgrep
    fd

    emacs-gtk
    emacsPackages.vterm

    # in-emacs gnupg prompts
    pinentry_emacs
    zstd
    
    # C#
    omnisharp-roslyn
    emacsPackages.omnisharp
    emacsPackages.dotnet
    mono
  ];
}
