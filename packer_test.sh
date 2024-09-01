distro=$1
version=$2

# Cleanup exisiting boxes
vagrant destroy -f
rm *.box || true
rm -Rf output-* || true
rm Vagrantfile || true
rm -Rf .vagrant/

# Build vbox image
packer build -on-error=ask -only=virtualbox-iso.$distro-$version .
vagrant box remove $distro$version
vagrant box add --name $distro$version $distro-Vagrant-virtualbox-$version.x86_64.box
vagrant init $distro$version
vagrant up
