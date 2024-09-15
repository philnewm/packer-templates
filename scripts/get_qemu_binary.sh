#!/bin/bash
# Source the OS release information
source /etc/os-release

# Determine the QEMU binary path based on the OS
if [[ "$ID_LIKE" == *"debian"* ]]; then
  echo "/usr/bin/qemu-system-x86_64"
else
  echo "/usr/libexec/qemu-kvm"
fi
