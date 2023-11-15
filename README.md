# Kubernetes Cluster Deployment on Proxmox using Terraform and Ansible

## Overview

This project provides infrastructure-as-code (IaC) scripts using Terraform and Ansible to automate the deployment and installation of a Kubernetes cluster on Proxmox Virtualization Environment. The playbook deploys virtual machines (VMs) to a single host, which makes it compatible with single node environments. In a clustered environment, the VMs can then be distrbiuted manually by the user.

The Kubernetes installation includes Docker containerd.io as container runtime and Calico Operator as CNI.

## Prerequisites

Before getting started, ensure you have the following prerequisites installed:

- Terraform: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Ansible: [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Proxmox API Access: Ensure you have API access to your Proxmox environment with the necessary permissions (See below).
- Cloudinit image: [Create a cloudinit template](https://pve.proxmox.com/wiki/Cloud-Init_Support)

## Create Proxmox API Token

```plaintext
pveum role add Provisioner -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit"
pveum user add terraform-user@pve --password <password>
pveum aclmod / -user terraform-user@pve -role Provisioner
```

## Configuration

- Adjust Provider credential variables in Terraform/proxmox_credentials.auto.tfvars
- Customize installation in Terraform/k8s_hosts_vars.vars
- If needed, override Ansible default variables in Ansible/vars.yml

## Usage

Provision VM's:
```bash
cd Ansible
ansible-playbook -i localhost, provision_hosts.yml
```

Install Kubernetes (using default inventory file Ansible/k8s-hosts):
```bash
cd Ansible
ansible-playbook install_cluster.yml
```

## Directory Structure

```plaintext
.
├── Ansible
│   ├── ansible.cfg
│   ├── destroy_hosts.yml
│   ├── install_cluster.yml
│   ├── provision_hosts.yml
│   ├── roles
│   │   ├── role-kubernetes-initialize-cluster
│   │   │   ├── defaults
│   │   │   │   └── main.yml
│   │   │   ├── files
│   │   │   │   └── add_kubeconfig.sh
│   │   │   ├── handlers
│   │   │   │   └── main.yml
│   │   │   ├── meta
│   │   │   │   └── main.yml
│   │   │   ├── README.md
│   │   │   └── tasks
│   │   │       ├── initialize_cluster.yml
│   │   │       └── main.yml
│   │   ├── role-kubernetes-install-cni
│   │   │   ├── defaults
│   │   │   │   └── main.yml
│   │   │   ├── meta
│   │   │   │   └── main.yml
│   │   │   ├── README.md
│   │   │   └── tasks
│   │   │       ├── install_calico.yml
│   │   │       └── main.yml
│   │   ├── role-kubernetes-install-components
│   │   │   ├── defaults
│   │   │   │   └── main.yml
│   │   │   ├── handlers
│   │   │   │   └── main.yml
│   │   │   ├── meta
│   │   │   │   └── main.yml
│   │   │   ├── README.md
│   │   │   └── tasks
│   │   │       ├── install_containered.yml
│   │   │       ├── install_docker.yml
│   │   │       ├── install_kubernetes.yml
│   │   │       └── main.yml
│   │   └── role-kubernetes-prepare-os
│   │       ├── meta
│   │       │   └── main.yml
│   │       ├── README.md
│   │       └── tasks
│   │           ├── main.yml
│   │           └── prepare_os.yml
│   └── vars.yml
├── LICENSE
├── README.md
└── Terraform
    ├── k8s_hosts_vars.tf
    ├── main.tf
    ├── provider.tf
    ├── proxmox_credentials.auto.tfvars
    └── templates
        └── k8s-hosts.tpl
```

## Contributing

If you'd like to contribute to this project, please follow the guidelines in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- Thanks to [Lachlan](https://lachlanlife.net) for inspirational blog posts.
- Made possible by [Opslogix](https://www.opslogix.com/).
