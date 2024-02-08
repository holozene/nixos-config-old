# Installing to a new system

This config is only intended for (U)EFI systems, if you modify it enough to work on DOS systems, look at the [See also][#See also/sources] section for resources on partitioning.

## Making the installation media

Since NixOS 14.11 the installer ISO is hybrid (bootable on CD and USB drives, and on EFI systems like modern motherboards and apple systems). These following instructions will assume copying the image to a USB drive. When using a CD or DVD, the usual methods to burn to disk should work with the iso.

- Download a [NixOS ISO image](https://nixos.org/download.html#nixos-iso), [create a custom ISO](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD), or use the (currently WIP) installer iso from the releases section on github.
- Plug in a USB drive large enough to accommodate the image.
- Follow the platform instructions:

### From Linux
- Find the USB drive with `lsblk` or `fdisk -l`.
    - Do not use `/dev/sdX1` or partitions of the disk, use the whole disk `/dev/sdX`.
- Copy to device: `cp nixos-xxx.iso /dev/sdX`
- Writing the disk image with `dd if=nixos-xxx.iso of=/dev/sdX bs=4M status=progress conv=fdatasync` also works.

### From macOS
- Find the USB drive with `diskutil list`.
    - Using rdiskX instead of diskX can make a large speed difference. You can check the write speed with `iostat 2` in another terminal.
- Unmount with: `diskutil unmountDisk diskX`.
- Burn with: `sudo dd if=nixos-xxx.iso of=/dev/diskX`.

### From Windows
- Download USBwriter.
- Start USBwriter.
- Choose the downloaded ISO as 'Source'
- Choose the USB drive as 'Target'
- Click 'Write'
- When USBwriter has finished writing, safely unplug the USB drive.

## Booting the installation media


## Installing onto the new system

### Partitioning
To prepare the target system, we must first create the necessary partitions on the hard drive. 

- Configure with: `sudo fdisk /dev/diskX` 
- For a very simple example setup follow instructions for DOS or (U)EFI:

#### fdisk

- `g` (gpt disk label)
- `n`
- `1` (partition number [1/128])
- `2048` first sector
- `+500M` last sector (boot sector size)
- `t`
- `1` (EFI System)
- `n`
- `2`
- `default` (fill up partition)
- `default` (fill up partition)
- `w` (write)

#### Label partitions
This is useful for having multiple setups and makes partitions easier to handle.

```sh
    lsblk
    sudo mkfs.fat -F 32 /dev/sdX1
    sudo fatlabel /dev/sdX1 NIXBOOT
    sudo mkfs.ext4 /dev/sdX2 -L NIXROOT
    sudo mount /dev/disk/by-label/NIXROOT /mnt
    sudo mkdir -p /mnt/boot
    sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot
```

#### Create swap file
The swap file is a place to hold low priority data intended for system ram but which the system does not have space to store, it is useful especially on systems with low ram.

```sh
    sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152 (2GB size)
    sudo chmod 600 /mnt/.swapfile
    sudo mkswap /mnt/.swapfile
    sudo swapon /mnt/.swapfile
```


## Setting this config up
If you have already partitioned correctly, 

### Clone the repository
```zsh
git clone https://github.com/holozene/nixos-config.git /etc/nixos
```

###
```zsh
cd /etc/nixos
sudo nixos-generate-config --show-hardware-config --root /mnt > system/hardware-configuration.nix
```

Also, if you have a differently named user account than my default, you *must* update the following lines in the let binding near the top of the [flake.nix][./flake.nix]:




# See also/sources: 
https://nixos.wiki/wiki/NixOS_Installation_Guide 
https://gitlab.com/librephoenix/nixos-config/-/blob/main/install.org