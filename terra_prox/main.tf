terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.8"
    }
  }
}
provider "proxmox" {
  pm_api_url = var.pm_api_url 
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure = true
}
resource "proxmox_vm_qemu" "kube-server" {
  count = 1
  name = "kube-server-0${count.index + 1}"
  target_node = "pve"  
  vmid = "40${count.index + 1}"
  clone = "ubuntu-2004-cloudinit-template"
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "stock"
    #storage_type = "zfspool"
    iothread = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  # network {
  #   model = "virtio"
  #   bridge = "vmbr8"
  # }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  nameserver = var.nameserver
  ipconfig0 = "ip=192.168.8.4${count.index + 1}/24,gw=192.168.1.1"
  ipconfig1 = "ip=10.17.0.4${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
resource "proxmox_vm_qemu" "kube-agent" {
  count = 2
  name = "kube-agent-0${count.index + 1}"
  target_node = "pve"
  vmid = "50${count.index + 1}"
  clone = "ubuntu-2004-cloudinit-template"
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "stock"
    #storage_type = "zfspool"
    iothread = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  # network {
  #   model = "virtio"
  #   bridge = "vmbr8"
  # }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  nameserver = var.nameserver
  ipconfig0 = "ip=192.168.8.5${count.index + 1}/24,gw=192.168.1.1"
  ipconfig1 = "ip=10.17.0.5${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
resource "proxmox_vm_qemu" "kube-storage" {
  count = 1
  name = "kube-storage-0${count.index + 1}"
  target_node = "pve"
  vmid = "60${count.index + 1}"
  clone = "ubuntu-2004-cloudinit-template"
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    size = "20G"
    type = "scsi"
    storage = "stock"
    #storage_type = "zfspool"
    iothread = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  # network {
  #   model = "virtio"
  #   bridge = "vmbr8"
  # }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  nameserver = var.nameserver
  ipconfig0 = "ip=192.168.8.6${count.index + 1}/24,gw=192.168.1.1"
  ipconfig1 = "ip=10.17.0.6${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}