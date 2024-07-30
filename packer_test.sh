# install virtualbox
# install packer
# install vagrant

# check for existing vagrant box
vagrant box list
rm -Rf .vagrant/
vagrant box remove alma9

# if Vagrantfile is present
rm Vagrantfile

packer build vbox_alma9.pkr.hcl
vagrant box add --name alma9 almalinux-9.4-virtualbox.box

vagrant init alma9
vagrant up alma9