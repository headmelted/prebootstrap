# debuilder
This repository periodically (currently once per month) creates a Debian rootfs from a debootstrap for every architecture that Debian supports, for use in chroot environments and for multi-arch compilation.

## How it works
debuilder uses QEMU and debootstrap's *foreign* and *second-stage* options to completely prepare a minimal root filesystem for use in chroot / embedded environments.

## Naming conventions
The releases tab holds downloadable tarballs, named in the format debuilder_rootfs_stretch_minbase_[architecture].tar.gz.