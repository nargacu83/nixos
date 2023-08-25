{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    xdg-utils
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/about" = ["firefox.desktop"];
        "x-scheme-handler/chrome"= ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/unknown" = ["firefox.desktop"];
        "application/x-extension-htm=" = ["firefox.desktop"];
        "application/x-extension-html" = ["firefox.desktop"];
        "application/x-extension-shtml" = ["firefox.desktop"];
        "application/x-extension-xht" = ["firefox.desktop"];
        "application/x-extension-xhtml" = ["firefox.desktop"];
        "application/pdf" = ["firefox.desktop"];
        "application/xhtml+xml" = ["firefox.desktop"];

        "image/gif" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/svg+xml" = [ "imv.desktop" ];
        "image/webp" = [ "imv.desktop" ];

        "video/mp4" = [ "mpv.desktop" ];
        "video/ogg" = [ "mpv.desktop" ];
        "video/x-flv" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/x-theora+ogg" = [ "mpv.desktop" ];
        "audio/mpeg" = ["mpv.desktop"];
        "audio/ogg" = ["mpv.desktop"];
        "audio/x-opus+ogg" = ["mpv.desktop"];
        "audio/x-vorbis+ogg" = ["mpv.desktop"];
        "audio/x-wav" = ["mpv.desktop"];

        "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
        "application/vnd.rar" = [ "org.gnome.FileRoller.desktop" ];
        "application/octet-stream" = [ "org.gnome.FileRoller.desktop" ];

        "application/json" =  [ "emacsclient.desktop" ];
        "application/x-shellscript" = [ "emacsclient.desktop" ];
        "application/x-wine-extension-ini" = [ "emacsclient.desktop" ];
        "application/xml" = [ "emacsclient.desktop" ];
        "text/plain" = [ "emacsclient.desktop" ];
        "text/x-csharp" = [ "emacsclient.deskto" ];
        "text/x-python" = [ "emacsclient.desktop" ];

        "text/csv" = [ "libreoffice-calc.desktop" ];
        "x-scheme-handler/freetube" = [ "freetube.desktop" ];
        "x-scheme-handler/unityhub" = [ "unityhub-handler.desktop" ];

        "inode/directory" = [ "nemo.desktop" ];
      };
    };
  };
}
