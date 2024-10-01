# Remaining Tasks

## Short Term

* vagrant cloud publish philnewm/debian12-gnome 0.1.1 virtualbox Debian.. --version-description "Fix non-opening terminal" --release
* Move reboots to handlers for one reboot at the end
* Fix broken gnome-terminal on debian
* Update debian12 + Ubuntu22.04 to use efi boot by default
* Add zstd to debian12 box for slightly faster package install process
* check for virtualbox guest additions version using `VBoxControl --version`
* Research [packer CI/CD integration](https://developer.hashicorp.com/packer/guides/packer-on-cicd/build-virtualbox-image)

## Long Term

* research how to manage static ip addresses for pre-made images
* research reasonable defaults kickstart information for vbox dev VMs/libvirt VMs
