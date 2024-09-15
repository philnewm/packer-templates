variable "os_ver_9" {
  description = "AlmaLinux OS 9 version"

  type    = string
  default = "9.4"

  validation {
    condition     = can(regex("9.[0-9]$|9.[1-9][0-9]$", var.os_ver_9))
    error_message = "The os_ver_9 value must be one of released or prereleased versions of AlmaLinux OS 9."
  }
}

locals {
  os_ver_major_9 = split(".", var.os_ver_9)[0]
  os_ver_minor_9 = split(".", var.os_ver_9)[1]
}

locals {
  alma_iso_url_9_x86_64       = "https://repo.almalinux.org/almalinux/${var.os_ver_9}/isos/x86_64/AlmaLinux-${var.os_ver_9}-x86_64-boot.iso"
  alma_iso_checksum_9_x86_64  = "file:https://repo.almalinux.org/almalinux/${var.os_ver_9}/isos/x86_64/CHECKSUM"
}

locals {
  rocky_iso_url_9_x86_64       = "https://dl.rockylinux.org/pub/rocky/${local.os_ver_major_9}/isos/x86_64/Rocky-${var.os_ver_9}-x86_64-boot.iso"
  rocky_iso_checksum_9_x86_64  = "file:https://dl.rockylinux.org/pub/rocky/${local.os_ver_major_9}/isos/x86_64/CHECKSUM"
}

locals {
  centosstream_iso_url_9_x86_64       = "https://mirror.stream.centos.org/${local.os_ver_major_9}-stream/BaseOS/x86_64/iso/CentOS-Stream-${local.os_ver_major_9}-latest-x86_64-boot.iso"
  centosstream_iso_checksum_9_x86_64  = "file:https://mirror.stream.centos.org/${local.os_ver_major_9}-stream/BaseOS/x86_64/iso/CentOS-Stream-${local.os_ver_major_9}-latest-x86_64-boot.iso.MD5SUM"
}

locals {
  ubuntu_iso_url_2204_x86_64       = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
  ubuntu_iso_checksum_2204_x86_64  = "file:https://releases.ubuntu.com/releases/22.04.5/SHA256SUMS"
}

locals {
  debian_iso_url_12_x86_64       = "https://cdimage.debian.org/cdimage/release/12.7.0/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso"
  debian_iso_checksum_12_x86_64  = "file:https://cdimage.debian.org/cdimage/release/12.7.0/amd64/iso-cd/SHA512SUMS"
}

# Common

variable "headless" {
  description = "Disable GUI"

  type    = bool
  default = true
}

variable "boot_wait" {
  description = "Time to wait before typing boot command"

  type    = string
  default = "10s"
}

variable "cpus" {
  description = "The number of virtual cpus"

  type    = number
  default = 4
}

variable "memory" {
  description = "The amount of memory"

  type    = number
  default = 2048
}

variable "post_cpus" {
  description = "The number of virtual cpus after the build"

  type    = number
  default = 2
}

variable "post_memory" {
  description = "The number of virtual cpus after the build"

  type    = number
  default = 4096
}

variable "http_directory" {
  description = "Path to a directory to serve kickstart files"

  type    = string
  default = "http"
}

variable "ssh_timeout" {
  description = "The time to wait for SSH to become available"

  type    = string
  default = "3600s"
}

variable "root_shutdown_command" {
  description = "The command to use to gracefully shut down the machine"

  type    = string
  default = "/sbin/shutdown -hP now"
}

variable "qemu_binary" {
  description = "Path of QEMU binary"

  type    = string
  default = "/usr/libexec/qemu-kvm"
}

variable "ovmf_code" {
  description = "Path of OVMF code file"

  type    = string
  default = "/usr/share/OVMF/OVMF_CODE.secboot.fd"
}

variable "ovmf_vars" {
  description = "Path of OVMF variables file"

  type    = string
  default = "/usr/share/OVMF/OVMF_VARS.secboot.fd"
}

variable "aavmf_code" {
  description = "Path of AAVMF code file"

  type    = string
  default = "/usr/share/AAVMF/AAVMF_CODE.fd"
}

# Vagrant

variable "vagrant_disk_size" {
  description = "The size in MiB of hard disk of VM"

  type    = number
  default = 25000
}

variable "vagrant_shutdown_command" {
  description = "The command to use to gracefully shut down the machine"

  type    = string
  default = "echo vagrant | sudo -S /sbin/shutdown -hP now"
}

variable "vagrant_ssh_username" {
  description = "The username to connect to SSH with"

  type    = string
  default = "vagrant"
}

variable "vagrant_ssh_password" {
  description = "A plaintext password to use to authenticate with SSH"

  type    = string
  default = "vagrant"
}

variable "vagrant_boot_command_8_x86_64_bios" {
  description = "Boot command for x86_64 BIOS"

  type = list(string)
  default = [
    "<tab>",
    " inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-8.vagrant-x86_64-bios.ks",
    "<enter><wait>",
  ]
}

local "alma_vagrant_boot_command_9_x86_64" {
  expression = [
    "c",
    "<wait>",
    "linuxefi /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=AlmaLinux-9-${local.os_ver_minor_9}-x86_64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-9.vagrant-x86_64.ks",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>",
  ]
}

local "rocky_vagrant_boot_command_9_x86_64" {
  expression = [
    "c",
    "<wait>",
    "linuxefi /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=Rocky-9-${local.os_ver_minor_9}-x86_64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky-9.vagrant-x86_64.ks",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>",
  ]
}

local "centosstream_vagrant_boot_command_9_x86_64" {
  expression = [
    "c",
    "<wait>",
    "linuxefi /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=CentOS-Stream-9-BaseOS-x86_64 ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centosstream-9.vagrant-x86_64.ks",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>",
  ]
}

local "ubuntu_vagrant_boot_command_2204_x86_64" {
  expression = [
    "<esc><esc><esc>",
    "c<wait>",
    "set gfxpayload=keep<enter><wait>",
    "linux /casper/vmlinuz <wait>",
    "autoinstall <wait>",
    "ds=\"nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\" <wait>",
    "---<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]
}

local "debian_vagrant_boot_command_12_x86_64" {
  expression = [
    "<wait><wait><wait><esc><wait><wait><wait>",
    "/install.amd/vmlinuz ",
    "initrd=/install.amd/initrd.gz ",
    "auto=true ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian-12-vagrant-x86_64.preseed ",
    "hostname=domain.localdomain ",
    "domain='' ",
    "interface=auto ",
    "vga=788 noprompt quiet --<enter>"
  ]
}

variable "alma9_vagrant_boot_command_9_x86_64_bios" {
  description = "Boot command for x86_64 BIOS"

  type = list(string)
  default = [
    "<tab>",
    "inst.text inst.gpt inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-9.vagrant-x86_64-bios.ks",
    "<enter><wait>",
  ]
}
