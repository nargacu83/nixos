# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };

  # FIXME: Add the rest of your current configuration

  networking.hostName = "nixos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.dbus.enable = true;
  security.polkit.enable = true;
  programs.mtr.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  networking.enableIPv6 = false;
  virtualisation.libvirtd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";

  # X11
  services.xserver = {
    enable = true;
    layout = "fr";

    # Touchpad
    libinput.enable = true;

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
  };

  # Wayland
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = false;
    };
    nvidiaPatches = false;
  };
  
  environment.systemPackages = with pkgs; [
    vim
    wget

    zsh
    zsh-completions
    spaceship-prompt

    git
    git-lfs
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

    # Archive
    unzip
    unrar

    # Printer
    epson-escpr
    epson-escpr2

    # Audio
    pavucontrol
    easyeffects

    # VM
    qemu
    virt-manager
    # Running in VM
    spice-vdagent

    # IO
    cinnamon.nemo
    gvfs
    gnome.file-roller

    # Programs
    stow
    dunst
    gammastep
    btop
    rofi
    alacritty
    firefox
    emacs
    libqalculate
    libreoffice-fresh
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
    godot
    godot_4
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

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.flatpak.enable = true;

  # TODO: Fonts

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    quentin = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0ITcd27IuHnhAEfjrr+NsHgCZWu4lp5QDeLDHs1+Yl"
      ];
      extraGroups = [ "wheel" "kvm" "input" "disk" "libvirtd" ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
