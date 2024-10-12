#!/bin/bash

distro=$1
version=$2
cap_distro="${distro^}"

echo "Building vagrant box for $cap_distro version $version"

rm Vagrantfile || true
rm -R .vagrant || true
vagrant box remove $distro$version || true

# Build vbox image
packer init .
packer build -on-error=ask -only=virtualbox-iso.$distro-$version .
vagrant box add --name $distro$version $cap_distro-$version-Vagrant-virtualbox.x86_64.box
vagrant init $distro$version
vagrant up
