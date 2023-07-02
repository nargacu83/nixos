# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
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
    gitui

    # Devices
    radeontop
    piper

    # X11
    picom-jonaburg
    sxhkd
    maim
    xclip
    nitrogen

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
    cinnamon.nemo-with-extensions
    gvfs
    gnome.file-roller

    # Programs
    dunst
    gammastep
    btop
    rofi
    alacritty
    firefox
    libqalculate
    # libreoffice-fresh
    yt-dlp

    # Media
    imv
    mpv
    freetube
    gimp
    krita
    inkscape

    # Development
    blender
    # godot
    godot_4
    # TODO: unstable.godot
    # TODO: unstable.godot_4
    scons
    docker
    jdk
    hugo
    cargo

    # Gaming
    gamemode
    mangohud
    lutris
    steam

    # Themes
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

  home.file = {
    "awesome" = {
      source = ../stow_home/awesome/.config/awesome;
      target = ".config/awesome";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
