rm Vagrantfile || true
rm -R .vagrant || true
vagrant box remove ubuntu || true

# Build vbox image
packer init .
packer build -on-error=ask -only=virtualbox-iso.ubuntu-2204 .
vagrant box add --name ubuntu Ubuntu-2204-Vagrant-virtualbox.x86_64.box
vagrant init ubuntu
vagrant up
