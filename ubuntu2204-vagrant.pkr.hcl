# AlmaLinux OS 9 Packer template for Vagrant boxes

source "qemu" "ubuntu-2204" {
  iso_url            = local.ubuntu_iso_url_2204_x86_64
  iso_checksum       = local.ubuntu_iso_checksum_2204_x86_64
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
  vm_name            = "Ubuntu-2204-Vagrant-Libvirt-${var.os_ver_9}-${formatdate("YYYYMMDD", timestamp())}.x86_64.qcow2"
  cpu_model          = "host"
  cpus               = var.cpus
  efi_boot           = true
  efi_firmware_code  = var.ovmf_code
  efi_firmware_vars  = var.ovmf_vars
  efi_drop_efivars   = true
  output_directory   = "output_qemu"
}

source "virtualbox-iso" "ubuntu-2204" {
  iso_url              = local.ubuntu_iso_url_2204_x86_64
  iso_checksum         = local.ubuntu_iso_checksum_2204_x86_64
  http_directory       = var.http_directory
  shutdown_command     = var.vagrant_shutdown_command
  ssh_username         = var.vagrant_ssh_username
  ssh_password         = var.vagrant_ssh_password
  ssh_timeout          = var.ssh_timeout
  boot_command         = local.ubuntu_vagrant_boot_command_2204_x86_64
  boot_wait            = var.boot_wait
  disk_size            = var.vagrant_disk_size
  guest_os_type        = "Ubuntu_64"
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
    ["modifyvm", "{{.Name}}", "--accelerate-2d-video", "on"]
  ]
}

build {
  sources = [
    "source.qemu.ubuntu-2204",
    "source.virtualbox-iso.ubuntu-2204"
  ]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    collections_path     = "./ansible/collections"
    roles_path           = "./ansible/roles"
    playbook_file        = "./ansible/vagrant-box.yml"
    ansible_env_vars = [
      "ANSIBLE_PIPELINING=True",
      "ANSIBLE_REMOTE_TEMP=/tmp",
      "ANSIBLE_SCP_EXTRA_ARGS=-O",
    ]
    extra_arguments = [
      "--extra-vars",
      "packer_provider=${source.type}",
    ]
    only = [
      "qemu.ubuntu-2204",
      "virtualbox-iso.ubuntu-2204"
    ]
  }
    post-processors {

    post-processor "vagrant" {
      compression_level = "9"
      output            = "Ubuntu-2204-Vagrant-{{.Provider}}-${var.os_ver_9}.x86_64.box"
      only = ["virtualbox-iso.almalinux-9"]
    }

    post-processor "vagrant" {
      compression_level    = "9"
      vagrantfile_template = "tpl/vagrant/vagrantfile-libvirt.rb"
      output               = "Ubuntu-2204-Vagrant-{{.Provider}}-${var.os_ver_9}.x86_64.box"
      only                 = ["qemu.almalinux-9"]
    }
  }
}
