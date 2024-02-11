#!/bin/bash

# Prompt user for the disk device
read -p "Enter the disk device (e.g., sda, nvme0n1) without /dev/. Use `lsblk` to find out: " disk

# Determine if the device is NVMe
if [[ $disk == nvme* ]]; then
  part_prefix="p"
else
  part_prefix=""
fi

# Confirm with the user
echo "You entered /dev/${disk}. This will ERASE ALL DATA on this disk."
read -p "Are you sure you want to continue? (y/n): " confirmation

if [ "$confirmation" != "y" ]; then
  echo "Operation cancelled."
  exit 1
fi

# Partition the disk
echo "Partitioning /dev/${disk}..."
parted /dev/${disk} -- mklabel gpt
parted /dev/${disk} -- mkpart primary 512MiB -3GiB
parted /dev/${disk} -- mkpart primary linux-swap -3GiB 100%
parted /dev/${disk} -- mkpart ESP fat32 1MiB 512MiB
parted /dev/${disk} -- set 3 esp on

# Format the partitions
echo "Formatting the partitions..."
mkfs.ext4 -L nixos /dev/${disk}${part_prefix}1
mkswap -L swap /dev/${disk}${part_prefix}2
mkfs.fat -F 32 -n boot /dev/${disk}${part_prefix}3

# Activate swap
echo "Activating swap..."
swapon /dev/${disk}${part_prefix}2

# Mount the partitions
echo "Mounting the partitions..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "Disk /dev/${disk} partitioned, formatted, and mounted successfully."

