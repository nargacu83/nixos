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

  # FIXME: Add the rest of your current configuration

  boot.loader.grub = {
    enable = true;
    # EFI
    device = "nodev";
    efiSupport = true;
    
    # Extremely slow (15 min to probe something)
    useOSProber = false; 
    extraEntries = ''
        menuentry 'Arch Linux (on /dev/sdc3)' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-simple-6f879637-bb97-47de-a3ea-d96a3356b5de' {
        insmod part_gpt
        insmod ext2
        set root='hd2,gpt3'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
        else
          search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
        fi
        linux /boot/vmlinuz-linux-lts root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
        initrd /boot/amd-ucode.img /boot/initramfs-linux-lts.img
      }
      submenu 'Advanced options for Arch Linux (on /dev/sdc3)' $menuentry_id_option 'osprober-gnulinux-advanced-6f879637-bb97-47de-a3ea-d96a3356b5de' {
        menuentry 'Arch Linux (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux-lts--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux-lts root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux-lts.img
        }
        menuentry 'Arch Linux, avec Linux linux-lts (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux-lts--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux-lts root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux-lts.img
        }
        menuentry 'Arch Linux, with Linux linux-lts (fallback initramfs) (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux-lts--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux-lts root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux-lts-fallback.img
        }
        menuentry 'Arch Linux, avec Linux linux (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux.img
        }
        menuentry 'Arch Linux, with Linux linux (fallback initramfs) (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux-fallback.img
        }
        menuentry 'Arch Linux (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux-lts--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux-lts root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux-lts.img
        }
        menuentry 'Arch Linux, avec Linux linux-lts (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux-lts--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux-lts root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux-lts.img
        }
        menuentry 'Arch Linux, with Linux linux-lts (fallback initramfs) (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux-lts--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux-lts root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux-lts-fallback.img
        }
        menuentry 'Arch Linux, avec Linux linux (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux.img
        }
        menuentry 'Arch Linux, with Linux linux (fallback initramfs) (on /dev/sdc3)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux--6f879637-bb97-47de-a3ea-d96a3356b5de' {
          insmod part_gpt
          insmod ext2
          set root='hd2,gpt3'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd2,gpt3 --hint-efi=hd2,gpt3 --hint-baremetal=ahci2,gpt3  6f879637-bb97-47de-a3ea-d96a3356b5de
          else
            search --no-floppy --fs-uuid --set=root 6f879637-bb97-47de-a3ea-d96a3356b5de
          fi
          linux /boot/vmlinuz-linux root=UUID=6f879637-bb97-47de-a3ea-d96a3356b5de rw loglevel=3 quiet amd_iommu=on iommu=pt video=efifb:off
          initrd /boot/amd-ucode.img /boot/initramfs-linux-fallback.img
        }
  }
    '';
    
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
  hardware = {
    bluetooth.enable = true;
    opengl = {
      driSupport = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
      ];
    };
  };

  virtualisation.libvirtd.enable = true;

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

    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
      };
    };

    displayManager.lightdm = {
      enable = true;
      background = ./lightdm/background.png;

      greeters.gtk = {
        enable = true;
        cursorTheme.name = "Adwaita";
        # font = {
        #   name = "Cantarell 10";
        #   package = pkgs.cantarell-fonts;
        # };
        iconTheme = {
          name = "Dracula";
          package = pkgs.dracula-icon-theme;
        };
        theme = {
          name = "Dracula";
          package = pkgs.dracula-theme;
        };
        indicators = [ "~session" "~power" ];
        extraConfig = ''
          hide-user-image = true
        '';
      };
  };

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
    # partitions created by arch requires a feature not available in stable
    unstable.e2fsprogs

    polkit_gnome
    vim
    wget

    zsh
    zsh-completions

    git
    git-lfs
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    histFile = "$XDG_CACHE_HOME/zsh.history";
  };

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

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      cantarell-fonts
      noto-fonts
      jetbrains-mono
      # winePackages.fonts
      # nerdfonts
      # google-fonts
    ];
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
