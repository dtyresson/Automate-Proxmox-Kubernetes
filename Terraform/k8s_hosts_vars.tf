variable "x_number_of" {
    default = 3
}

variable "ip_addresses" {
    description = "List of IP addresses for vms"
    type        = list(string)
    default     = ["xxx.xxx.xxx.10/24", "xxx.xxx.xxx.11/24", "xxx.xxx.xxx.12/24"]
}

variable "vm_name" {
    default = "k8s"
}

variable "memory" {
    default = "4096"
}

variable "memory_min_balloon" {
    default = "1024"
}

variable "cores" {
    default = "4"
}

variable "root_disk_size" {
    default = "20G"
}

variable "root_disk_storage_pool" {
    default = "<storage_pool_name>"
}

variable "ip_gateway" {
    type    = string
    default = "xxx.xxx.xxx.1"
}

variable "ip_vlan" {
    default = 0
}

variable "template_vm_name" {
    default = "<template_name>"
}

variable "nameserver_domain" {
    type    = string
    default = "<domain.name>"
}

variable "nameserver" {
    type    = string
    default = "1.1.1.1"
}

variable "user" {
    default = "username"
}

variable "sshkey" {
    default = "ssh-rsa AAAAB3NzaC... username@ansible.host"
}

variable "vmid_range" {
    default = <start_vm_id>
}