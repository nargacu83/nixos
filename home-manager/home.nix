# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./git.nix
    ./xdg.nix
    ./emacs.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.unstable-packages
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
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

    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    unstable.qt6Packages.qt6ct

    # Devices
    radeontop
    piper

    # X11
    picom-jonaburg
    sxhkd
    maim
    xcb-util-cursor
    xorg.xkill
    numlockx
    xclip
    nitrogen

    # Wayland
    hyprland
    slurp
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
    cinnamon.nemo-with-extensions
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

    # Media
    imv
    mpv
    gimp
    inkscape
    obs-studio
    obs-studio-plugins.obs-gstreamer
    obs-studio-plugins.obs-vaapi

    lutris
    mangohud

    # Development
    python310Packages.cffi
    python310Packages.cairocffi
    python310Packages.dbus-next
    python310Packages.xcffib
    cmake
    scons
    docker
    jdk
    hugo
    blender-hip
    # unstable.godot_4
    unityhub
    vscodium
    # Workaround for Unreal Engine to generate C++
    (pkgs.writeShellScriptBin "code" "exec -a $0 ${vscodium}/bin/codium $@")

    # Rust
    cargo
    rustc
    rustfmt

    # Themes
    gnome.dconf-editor
    gnome.adwaita-icon-theme
    dracula-theme
    dracula-icon-theme
  ];

  programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.waybar = {
    enable = true;
    # Enable Workspaces on Hyprland
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };

  xsession = {
    enable = true;
    windowManager.awesome.enable = true;
  };

  services.easyeffects = {
    enable = true;
    preset = "MonPetitProfil";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        # Japanese specific
        anthy
        fcitx5-anthy
    ];
  };

  home.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = 1;
    # Java applications fix, i don't remember for what
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # Multi languages keyboard
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    # QT Theme
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  home.pointerCursor = {
    name = "Bibata-Original-Classic";
    size = 16;
    package = pkgs.bibata-cursors;
    gtk.enable = true;
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
      name = "Bibata-Original-Classic";
      package = pkgs.bibata-cursors;
      size = 16;
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
      gtk-xft-rgba = "rgb";

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
      gtk-xft-rgba = "rbg";
      gtk-hint-font-metrics = 1;

      # Don't know what it does but hey, at least it's here
      gtk-primary-button-warps-slider=false;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-name = "Cantarell 10";
      document-font-name = "Cantarell 10";
      gtk-theme = "Dracula";
      icon-theme = "Dracula";
      cursor-theme = "Bibata-Original-Classic";
      cursor-size = 16;
      font-hinting = "full";
      font-antialiasing = "rgba";

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

  qt = {
    enable = true;
  };

  # home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink ./home/.zshrc;
  # home.file.".gnupg" = {
  #   source = config.lib.file.mkOutOfStoreSymlink ./home/.gnupg;
  #   recursive = true;
  # };

  home.file.".icons/default".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Original-Classic";
  home.file.".themes/default".source = "${pkgs.dracula-theme}/share/themes/Dracula";

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
