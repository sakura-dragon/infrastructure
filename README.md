# infrastructure

General Home Infrastructure

Managing python requirements using pipenv as otherwise it's a pain managing multiple python requirements:

```bash
sudo apt install python3-venv
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy install -r requirements.yaml
```

For the moment I've added the host IP's to the admin machines `/etc/hosts` file that ansible then uses to resolve hosts.

```bash
# Install
ansible-playbook -i inventory/main-cluster.ini install.yaml --become
# Sometimes rebooting can help ensure everything is started correctly
ansible-playbook -i inventory/main-cluster.ini reboot.yaml --limit k8s_cluster --become
```

# Design

Mostly for power saving reasons I've decided to base my infrastructure around a single node proxmox hypervisor host, and a dedicated proxmox backup server for incremental backups (PBS is my 2 in the 3-2-1 backups idealogy). For application deployment I've decided to keep as much of the infrastructure inside kubernetes as possible (due to it's flexibility and adaptability).

This gives me the following structure:

- Virtual OPNsense Router.
- Virtual two node k8s cluster (one controller and one worker).
- A VM for any services that don't play nicely with k8s.
- Dedicated external Proxmox Backup Server for disaster recovery.

This arrangement removes the need for running a distributed storage system on k8s, the larger hardware requirements per node that comes with that (additional HDD's and ideally networking), and the additional hardware and complexity for backups and restoration of the distributed system (this is only a homelab after all).

# Proxmox related notes

As I'm not running PVE in a HA mode, should be able to disable the following to reduce SSD wear:

```bash
systemctl disable pve-ha-crm.service
systemctl disable pve-ha-lrm.service
```
