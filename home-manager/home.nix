# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./xdg.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "quentin";
    homeDirectory = "/home/quentin";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Diff tool for nix packages
    nvd
    gitui

    pciutils
    networkmanagerapplet

    # Devices
    radeontop
    piper

    # X11
    picom-jonaburg
    sxhkd
    maim
    xclip
    nitrogen
    xcb-util-cursor

    # Wayland
    hyprland
    waybar
    swww

    # Archive
    unzip
    unrar

    # Audio
    pavucontrol
    easyeffects

    # VM
    qemu
    virt-manager
    # Running in VM
    spice-vdagent

    # IO
    gnome.nautilus
    gvfs
    gnome.file-roller
    gparted
    gnome.gnome-disk-utility

    # Programs
    dunst
    gammastep
    btop
    rofi-wayland
    grim
    alacritty
    firefox
    libqalculate
    libreoffice-fresh
    yt-dlp
    sonixd
    nextcloud-client
    syncplay

    # Input methods
    fcitx5
    # Japanese specific
    fcitx5-mozc
    fcitx5-anthy
    anthy

    # Media
    imv
    mpv
    freetube
    gimp
    krita
    inkscape

    # Development
    emacs-gtk
    emacsPackages.vterm
    ripgrep
    fd
    cmake
    vscodium
    blender
    unstable.godot_4
    scons
    docker
    jdk
    hugo
    cargo

    # Gaming
    unstable.mesa
    gamemode
    mangohud
    unstable.lutris
    steam

    # Themes
    gnome.dconf-editor
    gnome.adwaita-icon-theme
    dracula-theme
    dracula-icon-theme
  ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName  = "Quentin Franchi";
    userEmail = "dev.quentinfranchi@protonmail.com";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  xsession = {
    windowManager.awesome.enable = true;
  };

  services.emacs.enable = true;
  services.easyeffects = {
    enable = true;
    preset = "MonPetitProfil";
  };

  home.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    font = {
      name = "Cantarell 10";
      package = pkgs.cantarell-fonts;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    cursorTheme = {
      name = "Adwaita";
    };
    gtk3.extraConfig = {
      # Dark theme
      gtk-application-prefer-dark-theme = true;

      # Remove min-max-close buttons
      gtk-decoration-layout = "";

      # Disable middle-click paste
      gtk-enable-primary-paste = false;

      # Disable events sounds
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;

      # Disable recent files
      gtk-recent-files-limit = 0;
      gtk-recent-files-max-age = 0;

      # Prevent blurry font
      gtk-xft-antialias = 1;
      gtk-xft-dpi = 98304;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
      gtk-hint-font-metrics = 1;

      # Don't know what it does but hey, at least it's here
      gtk-primary-button-warps-slider=false;
    };

    gtk4.extraConfig = {
      # Dark theme
      gtk-application-prefer-dark-theme = true;

      # Remove min-max-close buttons
      gtk-decoration-layout = "";

      # Disable middle-click paste
      gtk-enable-primary-paste = false;

      # Disable events sounds
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;

      # Disable recent files
      gtk-recent-files-max-age = 0;

      # Prevent blurry font
      gtk-xft-antialias = 1;
      gtk-xft-dpi = 98304;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
      gtk-hint-font-metrics = 1;

      # Don't know what it does but hey, at least it's here
      gtk-primary-button-warps-slider=false;
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Dracula";
      icon-theme = "Dracula";

      # Disable middle-click paste
      gtk-enable-primary-paste = false;
    };
    # Remove min-max-close buttons
    "org/gnome/desktop/wm/preferences" = {
      theme = "Dracula";
      button-layout = "";
    };
    # Disable events sounds
    "org/gnome/desktop/sound" = {
      event-sounds = false;
      input-feedback-sounds = false;
    };
    # Disable recent files
    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
      recent-files-max-age = 0;
    };
  };
  # home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink ./home/.zshrc;
  # home.file.".gnupg" = {
  #   source = config.lib.file.mkOutOfStoreSymlink ./home/.gnupg;
  #   recursive = true;
  # };


  home.file.".zshrc".source = ./home/.zshrc;
  home.file.".gnupg" = {
    source = ./home/.gnupg;
    recursive = true;
  };

  home.file.".config" = {
    source = ./home/.config;
    recursive = true;
  };

  home.file.".local" = {
    source = ./home/.local;
    recursive = true;
  };

  # home.file.".config/mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink ./home/.config;
  home.file.".config/easyeffects" = {
    source = ./home/.config/easyeffects;
    recursive = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
