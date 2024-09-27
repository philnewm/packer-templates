vagrant cloud publish philnewm/centosstream9.4-gnome 0.1.0 virtualbox CentOSStream-9.4-Vagrant-virtualbox.x86_64.box -d "CentOSStream9.4 virtualbox as desktop enabled development box" --version-description "Initial release"

vagrant cloud version create philnewm/centosstream9.4-gnome 0.1.0 --description "CentOSStream9.4 virtualbox as desktop enabled development box"
vagrant cloud provider upload philnewm/centosstream9.4-gnome version_number virtualbox CentOSStream-9.4-Vagrant-virtualbox.x86_64.box --architecture=x86_64