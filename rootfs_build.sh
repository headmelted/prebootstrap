#!/bin/bash

echo "Installing debootstrap and QEMU";
sudo apt-get install -y debootstrap qemu-user-static;

echo "Using debootstrap --foreign to create rootfs for [$2] jail"
sudo debootstrap --foreign --verbose --arch=$2 --variant=minbase $1 rootfs;

echo "Manually mounting proc, sys and dev into rootfs";
cd rootfs;
sudo mount --bind /dev dev/
sudo mount --bind /sys sys/
sudo mount --bind /proc proc/
sudo mount --bind /dev/pts dev/pts
cd ..;
    
echo "Marking static [rootfs/usr/bin/qemu-$ROOTFS_QEMU_ARCH-static] as executable";
sudo chmod +x rootfs/usr/bin/qemu-$ROOTFS_QEMU_ARCH-static;

echo "Manually setting up debootstrap";
sudo chroot rootfs /debootstrap/debootstrap --second-stage --verbose;
