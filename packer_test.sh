rm Vagrantfile || true
rm -R .vagrant || true
vagrant box remove debian12 || true

# Build vbox image
packer build -on-error=ask -only=virtualbox-iso.debian-12 .
vagrant box add --name debian12 Debian-12-Vagrant-virtualbox.x86_64.box
vagrant init debian12
vagrant up
