{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  config = {
    allowUnfree = true;
  };

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
    # useXkbConfig = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Display Manager / Login Manager
  services.greetd = {
    enable = true;
  };

  # X11
  services.xserver = {
    enable = true;
    layout = "fr";

    # Touchpad
    libinput.enable = true;

    windowManager.awesome.enable = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };

  };

  # services.printing.enable = true;

  sound.enable = true;
  services.pipewire.enable = true;
  networking.networkmanager.enable = true;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # programs.hyprland = {
  #   enable = true;
  #   xwayland = {
  #     enable = true;
  #   };
  # };

  users.users.quentin = {
    isNormalUser = true;
    extraGroups = [ "wheels" ];
    initialPassword = "password"
    packages = with pkgs; [
      firefox
      alacritty
      emacs
    ];
  };

  system.stateVersion = "unstable";
}
