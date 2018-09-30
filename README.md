# prebootstrap
This repository periodically (currently once per month) creates a Debian Stretch minimal root filesystem for every architecture that Debian supports (by calling *debootstrap*). I'm currently using these for multi-arch builds on Azure Pipelines (where the packaging takes place), but they should be useful for most scenarios requiring root filesystems for multiple architectures.

## Why make this?
It's relatively easy to find root filesystems for most Linux distributions on the internet, including Ubuntu (who make official releases of root filesystems for datacenter use).  I prefer working with Debian as I find there is much better coverage of different architectures, and I've found the package naming to be more consistent.  As I was unable to find downloaded root filesystem tarballs on the internet, I decided to build some for my own use (but hopefully they're useful to you too!).

## How it works
prebootstrap uses QEMU and debootstrap's *foreign* and *second-stage* options to fully setup the filesystem, which is then tarballed and tagged to a release for that month on Github (the release tab above).  This should make it easy to lock versions to a filesystem for a specific month.  To download a filesystem with a more recent set of packages just change the month and year in your scripts.

## Naming conventions
The releases tab holds the downloads, which are tagged and named in the format prebootstrap_rootfs_stretch_minbase_[architecture].tar.gz.
