{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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
    awesome
    hyprland
  ];

  # X11
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;

  services.printing.enable = true;

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
    packages = with pkgs; [
      firefox
      alacritty
      emacs
    ];
  };

  system.stateVersion = "unstable";
}
