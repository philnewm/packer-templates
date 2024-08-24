# vbox-guest

An Ansible role that installs VirtualBox Guest Additions on a virtual machine.


## Role Variables

The role variables and their default values are listed below:

* `vbox_additions_iso_path: '/home/vagrant/VBoxGuestAdditions.iso'` -
  path to a VirtualBox Guest Additions ISO on a VM.


## Example Playbook

```yaml
---
- hosts: all
  roles:
    - { role: ezamriy.vbox-guest,
        vbox_additions_iso_path: '/root/VBoxGuestAdditions.iso' }
```


## Development

The role uses [Molecule](https://github.com/ansible-community/molecule) for
tests. After installing [VirtualBox](https://www.virtualbox.org/),
[Vagrant](https://www.vagrantup.com/) and dependencies from the
`requirements.txt` file you will be able to run tests with the following
command:

```sh
$ molecule test
```


## License

MIT


## Authors

* [Eugene Zamriy](https://github.com/ezamriy)
