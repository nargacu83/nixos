# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager

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

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      # Import your home-manager configuration
      quentin = import ../home-manager/home.nix;
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

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
    enableIPv6 = false;
  };

  # services.printing = {
  #   enable = true;
  #   drivers = with pkgs; [
  #     epson-escpr
  #     epson-escpr2
  #   ];
  #   browsing = true;
  #   defaultShared = false;
  # };

  # services.blueman.enable = true;
  # hardware = {
  #   bluetooth.enable = true;
  #   opengl.extraPackages = with pkgs; [
  #     rocm-opencl-icd
  #   ];
  # };

  # virtualisation.libvirtd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  i18n.defaultLocale = "fr_FR.UTF-8";
  time.timeZone = "Europe/Paris";

  environment = {
    variables = {
      # Use qt5ct for theming QT apps
      QT_QPA_PLATFORMTHEME = "qt5ct";
      # Java applications fix, i don't remember for what
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # Multi languages keyboard
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
  };

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
  ];

  programs.java.enable = true;

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-utils
    ];
  };

  services.flatpak.enable = true;

  # fonts = {
  #   fontDir.enable = true;
  #   fonts = with pkgs; [
  #     cantarell-fonts
  #     noto-fonts
  #     jetbrains-mono
  #     winePackages.fonts
  #     nerdfonts
  #     google-fonts
  #   ];
  # };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    quentin = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "password";
      isNormalUser = true;
      extraGroups = [ "wheel" "kvm" "input" "disk" "libvirtd" "networkmanager" ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
