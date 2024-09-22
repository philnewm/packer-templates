packer {
  required_version = ">= 1.7.0"
  required_plugins {
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
    qemu = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/qemu"
    }
    vagrant = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}