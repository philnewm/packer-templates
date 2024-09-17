rm Vagrantfile || true
rm -R .vagrant || true
vagrant box remove alma9 || true

# Build vbox image
packer build -on-error=ask -only=virtualbox-iso.almalinux-9 .
vagrant box add --name alma9 AlmaLinux-9-Vagrant-virtualbox-9.4.x86_64.box
vagrant init alma9
vagrant up
