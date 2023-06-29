#!/usr/bin/env sh

echo " >> Installing NixOS configuration"
sleep 1
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix nixos/hardware-configuration.nix
nixos-install --root /mnt --flake .#nixos
