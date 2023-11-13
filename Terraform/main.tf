
resource "proxmox_vm_qemu" "proxmox_kubernetes_vms" {
  count = var.x_number_of
  name  = "${var.vm_name}-${count.index + 1}"
  ipconfig0   = "gw=${var.ip_gateway},ip=${var.ip_addresses[count.index]}"
  target_node = "pve5"
  onboot      = true
  # Same CPU as the Physical host, possible to add cpu flags
  # Ex: "host,flags=+md-clear;+pcid;+spec-ctrl;+ssbd;+pdpe1gb"
  cpu   = "host"
  numa  = false
  clone = "${var.template_vm_name}"
  full_clone = true
  os_type    = "cloud-init"
  agent      = 1
  ciuser     = var.user
  memory     = var.memory
  balloon    = var.memory_min_balloon
  cores      = var.cores
  nameserver = var.nameserver
  sshkeys    = var.sshkey
  vmid       = var.vmid_range+count.index
  qemu_os    = "l26"
  tags       = "k8s"

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.ip_vlan
  }

  serial {
    id   = 0
    type = "socket"
  }

  vga {
    type = "serial0"
  }

  disk {
    size    = var.root_disk_size
    storage = var.root_disk_storage_pool
    backup  = true
    type = "scsi"
  }

  lifecycle {
    ignore_changes = [
      network, disk, sshkeys, target_node
    ]
  }
}


data "template_file" "k8s" {
  template = file("./templates/k8s-hosts.tpl")
  vars = {
    k8s_master = "${join("", [proxmox_vm_qemu.proxmox_kubernetes_vms[0].instance.name, " ansible_host=", proxmox_vm_qemu.proxmox_kubernetes_vms[0].instance.default_ipv4_address])}"
    k8s_workers = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_kubernetes_vms[1:] : join("", [instance.name, " ansible_host=", instance.default_ipv4_address])])}"
  }
}

resource "local_file" "k8s_file" {
  content  = data.template_file.k8s.rendered
  filename = "../Ansible/k8s-hosts"
}

output "Host IPs" {
  value = ["${proxmox_vm_qemu.proxmox_kubernetes_vms.*.default_ipv4_address}"]
}