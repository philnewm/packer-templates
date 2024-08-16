packer {
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1"
    }
    ansible = {
      source = "github.com/hashicorp/ansible"
      version = ">= 1.1.1"
    }
  }
}


local "vagrant_boot_command_9_x86_64" {
  expression = [
    "c",
    "<wait>",
    "linuxefi /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=AlmaLinux-9-4-x86_64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-9.vagrant-x86_64.ks",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>"
  ]
}

source "virtualbox-iso" "almalinux-9" {
  iso_url              = "https://repo.almalinux.org/almalinux/9.4/isos/x86_64/AlmaLinux-9.4-x86_64-boot.iso"
  iso_checksum         = "file:https://repo.almalinux.org/almalinux/9.4/isos/x86_64/CHECKSUM"
  boot_command         = local.vagrant_boot_command_9_x86_64
  boot_wait            = "10s"
  cpus                 = 4
  memory               = 2048
  disk_size            = 20000
  headless             = true
  http_directory       = "http"
  guest_os_type        = "RedHat_64"
  shutdown_command     = "echo vagrant | sudo -S /sbin/shutdown -hP now"
  ssh_username         = "vagrant"
  ssh_password         = "vagrant"
  ssh_timeout          = "3600s"
  hard_drive_interface = "sata"
  iso_interface        = "sata"
  firmware             = "efi"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
  ]
  vboxmanage_post = [
    ["modifyvm", "{{.Name}}", "--cpus", 2],
    ["modifyvm", "{{.Name}}", "--memory", 4096],
    ["modifyvm", "{{.Name}}", "--uartmode1", "disconnected"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{.Name}}", "--vram", "256"],
    ["modifyvm", "{{.Name}}", "--accelerate-3d", "off"],
    ["modifyvm", "{{.Name}}", "--accelerate-2d-video", "on"]
  ]
}

build {
  sources = ["source.virtualbox-iso.almalinux-9"]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    collections_path     = "./ansible/collections"
    roles_path           = "./ansible/roles"
    playbook_file        = "./ansible/vagrant-box.yml"
    ansible_env_vars = [
      "ANSIBLE_PIPELINING=True",
      "ANSIBLE_REMOTE_TEMP=/tmp",
      "ANSIBLE_SCP_EXTRA_ARGS=-O"
    ]
    extra_arguments = [
      "--extra-vars",
      "packer_provider=${source.type}"
    ]
  }

  post-processor "vagrant" {
    compression_level = "9"
    output            = "almalinux-9.4-{{ .Provider }}.box"
  }
}
