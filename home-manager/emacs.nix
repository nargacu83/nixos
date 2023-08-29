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

    emacs29-pgtk # Wayland
    # emacs29-gtk3
    emacsPackages.vterm

    # in-emacs gnupg prompts
    pinentry_emacs
    zstd
    
    # C#
    omnisharp-roslyn
    emacsPackages.omnisharp
    emacsPackages.dotnet
    mono

    # Python
    python3Full
  ];
}
