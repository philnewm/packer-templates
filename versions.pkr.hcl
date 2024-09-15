packer {
  required_version = ">= 1.7.0"
  required_plugins {
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/packer-plugin-ansible"
    }
    qemu = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/packer-plugin-qemu"
    }
    vagrant = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/packer-plugin-vagrant"
    }
    virtualbox = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/packer-plugin-virtualbox"
    }
  }
}