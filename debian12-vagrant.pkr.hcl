# AlmaLinux OS 9 Packer template for Vagrant boxes

source "qemu" "debian-12" {
  iso_url            = local.debian_iso_url_12_x86_64
  iso_checksum       = local.debian_iso_checksum_12_x86_64
  http_directory     = var.http_directory
  shutdown_command   = var.vagrant_shutdown_command
  ssh_username       = var.vagrant_ssh_username
  ssh_password       = var.vagrant_ssh_password
  ssh_timeout        = var.ssh_timeout
  boot_command       = local.ubuntu_vagrant_boot_command_2204_x86_64
  boot_wait          = var.boot_wait
  accelerator        = "kvm"
  disk_interface     = "virtio-scsi"
  disk_size          = var.vagrant_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_compression   = true
  format             = "qcow2"
  headless           = var.headless
  machine_type       = "q35"
  memory             = var.memory
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  vm_name            = "Debian-12-Vagrant-Libvirt-${var.os_ver_9}-${formatdate("YYYYMMDD", timestamp())}.x86_64.qcow2"
  cpu_model          = "host"
  cpus               = var.cpus
  efi_boot           = true
  efi_firmware_code  = var.ovmf_code
  efi_firmware_vars  = var.ovmf_vars
  efi_drop_efivars   = true
  output_directory   = "output_qemu"
}

source "virtualbox-iso" "debian-12" {
  iso_url              = local.debian_iso_url_12_x86_64
  iso_checksum         = local.debian_iso_checksum_12_x86_64
  http_directory       = var.http_directory
  shutdown_command     = var.vagrant_shutdown_command
  ssh_username         = var.vagrant_ssh_username
  ssh_password         = var.vagrant_ssh_password
  ssh_timeout          = var.ssh_timeout
  boot_command         = local.debian_vagrant_boot_command_12_x86_64
  boot_wait            = var.boot_wait
  disk_size            = var.vagrant_disk_size
  guest_os_type        = "Debian_64"
  cpus                 = var.cpus
  memory               = var.memory
  headless             = var.headless
  hard_drive_interface = "sata"
  iso_interface        = "sata"
  output_directory     = "output_vbox"
  vboxmanage           = [["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"]]
  vboxmanage_post = [
    ["modifyvm", "{{.Name}}", "--memory", var.post_memory],
    ["modifyvm", "{{.Name}}", "--cpus", var.post_cpus],
    ["modifyvm", "{{.Name}}", "--uartmode1", "disconnected"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{.Name}}", "--vram", "256"],
    ["modifyvm", "{{.Name}}", "--accelerate-3d", "off"],
    ["modifyvm", "{{.Name}}", "--accelerate-2d-video", "on"],
    ["modifyvm", "{{.Name}}", "--clipboard-mode", "bidirectional"]
  ]
}

build {
  sources = [
    "source.qemu.debian-12",
    "source.virtualbox-iso.debian-12"
  ]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    collections_path     = "./ansible/collections"
    roles_path           = "./ansible/roles"
    playbook_file        = "./ansible/vagrant-box.yml"
    ansible_env_vars = [
      "ANSIBLE_PIPELINING=True",
      "ANSIBLE_FORCE_COLOR=true",
      "ANSIBLE_STDOUT_CALLBACK=debug",
      "ANSIBLE_CALLBACKS_ENABLED=debug",
      "ANSIBLE_REMOTE_TEMP=/tmp"
    ]
    extra_arguments = [
      "--extra-vars",
      "packer_provider=${source.type}",
    ]
    only = [
      "qemu.debian-12",
      "virtualbox-iso.debian-12"
    ]
  }
    post-processors {

    post-processor "vagrant" {
      compression_level = "9"
      output            = "Debian-12-Vagrant-{{.Provider}}.x86_64.box"
      only = ["virtualbox-iso.debian-12"]
    }

    post-processor "vagrant" {
      compression_level    = "9"
      vagrantfile_template = "tpl/vagrant/vagrantfile-libvirt.rb"
      output               = "Debian-12-Vagrant-{{.Provider}}.x86_64.box"
      only                 = ["qemu.debian-12"]
    }
  }
}
