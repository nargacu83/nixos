#!/usr/bin/env sh

function set_disk_partition () {
    lsblk -f
    read -p "Select your disk (eg. /dev/sda): " s_disk
    echo ""
    read -p "Are you sure is it your disk, all the data will be erased (${s_disk})? [Y/n] " disk_confirmation
    if [ "${disk_confirmation}" != "Y" ] && [ "${disk_confirmation}" != "y" ]; then
        echo "Exiting script.."
        exit 1
    fi

    if [ "${s_disk::8}" == "/dev/nvm" ]; then
        p_disk="${s_disk}p"
    else
        p_disk="${s_disk}"
    fi

    read -p "Enter your swap size (eg. 8): " swap_size

    # GPT partition table
    parted ${s_disk} -- mklabel gpt
    # File System
    parted ${s_disk} -- mkpart primary 512MB -${swap_size}GB
    # Swap partition
    parted ${s_disk} -- mkpart primary linux-swap -${swap_size}GB 100%

    parted ${s_disk} -- mkpart ESP fat32 1MB 512MB
    parted ${s_disk} -- set 3 esp on
}

function set_partition_tables () {
    echo " >> Setting the partitions tables"
    sleep 1
    # File System partition
    mkfs.ext4 -L nixos "${p_disk}1"
    # Swap partition
    mkswap -L swap "${p_disk}2"
    swapon "${p_disk}2"
    # EFI partition
    mkfs.fat -F 32 -n boot "${p_disk}3"
}

function mount_file_system () {
    echo " >> Mounting the file system"
    sleep 1
    # File System partition
    mount /dev/disk/by-label/nixos /mnt
    # Boot partition
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
}

set_disk_partition
set_partition_tables
mount_file_system

echo " >> Installing NixOS configuration"
sleep 1
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix nixos/hardware-configuration.nix
nixos-install --flake .#nixos
