# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
    alacritty
    firefox
    libqalculate
    libreoffice-fresh
    yt-dlp
    sonixd
    nextcloud-client

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
    unstable.unityhub

    # Gaming
    unstable.mesa
    gamemode
    mangohud
    unstable.lutris
    steam

    # Themes
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
    };
    "org/gnome/desktop/wm/preferences" = {
      theme = "Dracula";
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

  home.file.".config/mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink ./home/.config;
  home.file.".config/easyeffects" = {
    source = ./home/.config/easyeffects;
    recursive = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
