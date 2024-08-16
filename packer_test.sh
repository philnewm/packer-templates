# install virtualbox
# install packer
# install vagrant

# Cleanup exisiting boxes
rm *.box || true
rm -Rf output-* || true

# Remove existing vagrant boxes
vagrant destroy -f
vagrant box prune
vagrant box list | awk '{print $1}' | xargs -n 1 vagrant box remove -f
rm -Rf .vagrant/
rm Vagrantfile

# Build vbox image
packer build -on-error=ask vbox_alma9.pkr.hcl
vagrant box add --name alma9 almalinux-9.4-virtualbox.box

vagrant init alma9
vagrant up alma9
