{ config, lib, pkgs, ... }:

{
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
}
