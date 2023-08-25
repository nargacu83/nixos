# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager

    # You can also split up your configuration and import pieces of it here:
    ./grub.nix
    ./lightdm
    ./video.nix
    ./systemd.nix
    ./wine.nix
    ./flatpak.nix
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      quentin = import ../home-manager/home.nix;
    };
  };

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
  services.gvfs.enable = true;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  programs.mtr.enable = true;
  programs.dconf.enable = true;

  networking = {
    hostName = "nixos";
    enableIPv6 = false;
    networkmanager.enable = true;
    firewall.enable = false;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      epson-escpr
      epson-escpr2
    ];
    browsing = true;
    defaultShared = false;
  };

  services.blueman.enable = true;
  hardware = {
    bluetooth.enable = true;
    opengl = {
      # Rendering through the Direct Rendering Interface
      driSupport = true;
      driSupport32Bit = true;

      # Hardware Acceleration
      extraPackages = with pkgs; [
        rocm-runtime
        rocm-opencl-icd
        libva
      ];
    };
    steam-hardware.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

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

  # X11
  services.xserver = {
    enable = true;
    layout = "fr";

    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
      };
    };

    windowManager = {
      awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks # is the package manager for Lua modules
          luadbi-mysql # Database abstraction layer
        ];
      };
      # qtile = {
      #   enable = true;
      #   extraPackages = python3Packages: with python3Packages; [
      #     python-lsp-server
      #     qtile-extras
      #   ];
      # };
    };
  };

  services.ratbagd.enable = true;

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
    # partitions created by arch requires a feature not available in stable
    unstable.e2fsprogs

    glib
    polkit_gnome
    vim
    wget

    zsh
    zsh-completions
    zsh-syntax-highlighting

    git
    git-lfs
    docker

    # Appimages
    appimage-run
    fuse

    # Gaming
    lutris
    mesa
    gamemode
    gamescope
    mangohud
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    histFile = "$XDG_CACHE_HOME/zsh.history";
  };

  programs.java.enable = true;

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-utils
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      cantarell-fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      dejavu_fonts
      ubuntu_font_family
      source-code-pro
      jetbrains-mono
      emacs-all-the-icons-fonts
      winePackages.fonts
      nerdfonts
      ipafont
    ];

    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      # defaultFonts = {
      #   monospace = [ "JetBrains Mono" ];
      #   sansSerif = [ "Noto Serif" ];
      #   serif = [ "Noto Sans" ];
      # };
    };
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users = {
    defaultUserShell = pkgs.zsh;

    users = {
      quentin = {
        # TODO: You can set an initial password for your user.
        # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
        # Be sure to change it (using passwd) after rebooting!
        initialPassword = "password";
        isNormalUser = true;
        extraGroups = [ "wheel" "kvm" "input" "disk" "libvirtd" "networkmanager" ];
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
