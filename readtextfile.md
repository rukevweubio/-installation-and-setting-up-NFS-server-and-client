##  NFS Server Installation and Configuration
## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
- [Configuration Steps](#configuration-steps)
- [Testing and Verification](#testing-and-verification)
- [Troubleshooting](#troubleshooting)
- [Maintenance](#maintenance)
- [Contributing](#contributing)
- [License](#license)

## Introduction
Network File System (NFS) is a distributed file system protocol that allows users to share and access files over a network as if
they were stored locally. Originally developed by Sun Microsystems, NFS enables seamless file sharing between Linux, Unix, 
and even Windows systems, making it a powerful solution for network-based storage.
- NFS provides several key advantages:
Centralized Storage: Multiple clients can access shared files from a single NFS server.
Scalability: Works well for small to large-scale enterprise environments.
Efficiency: Reduces the need for duplicate files across different systems.
Interoperability: Can be used across different operating systems (Linux, Unix, macOS, and Windows).
Performance Optimization: Supports features like caching and asynchronous writes for better speed.

## Prerequisites
Before proceeding, ensure the following prerequisites are met:
- Operating System: Ubuntu 22.04 LTS or later
- Disk Space: At least 1 GB free space
- Network Configuration: Static IP address assigned to the server
- Required Packages: `nfs-kernel-server`, `nfsclient`

---

## Installation Steps
Follow these steps to install the Samba server:

1. Update the system:
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install nfs-kernel-server -y
   sudo systemctl start nsf-kernel-server
  sudo systemctl enable nfs-kernel-server
  sudo systemctl status nfs-kernel-server
  ```
## Configuration Steps
```
sudo mkdir -p /home/samba/shared
sudo chmod 777 /home/samba/shared
sudo mkdir -p /mnt/nfsshare
sudo chmod 777 /mnt/nfsshare
sudo chown nobody:nogroup /mnt/nfsshare
  ```
```
Edit the Exports File
Edit the /etc/exports file to specify which directories should be shared:
```
sudo nano /etc/exports
/mnt/nfsshare 192.168.XXX/24(rw,sync,no_subtree_check)
sudo exportfs -a
sudo exportfs -v

```
## Testing and Verification
From the NFS Server
```
showmount -e localhost

```
## From an NFS Client
install  the client server
```

sudo apt install nfs-common -y
sudo mkdir -p /mnt/nfsclient
sudo mount -t nfs 192.168.XXXX:/mnt/nfsshare /mnt/nfsclient
check the disk
df -h | grep nfs
```
## Troubleshooting
Common Issues and Solutions:
Issue: Unable to mount the NFS share.
Solution: Check firewall rules and ensure the NFS service is running

```
sudo ufw allow nfs
sudo systemctl status nfs-kernel-server
sudo chmod 777 /mnt/nfsshare
sudo chown nobody:nogroup /mnt/nfsshare
sudo mount -t nfs 192.168.1.100:/mnt/nfsshare /mnt/nfsclient
````
## Maintenance 
Updating NFS
Regularly update the NFS packages to ensure security and stability:

```
sudo apt update && sudo apt upgrade -y


```

## Managing Logs
Monitor NFS logs for troubleshooting:
``` sudo tail -f /var/log/syslog
```
Additional Features
Automounting with /etc/fstab
To automatically mount the NFS share on boot, add an entry to /etc/fstab on the client
```
192.168.1.xxx:/mnt/nfsshare /mnt/nfsclient nfs defaults,timeo=14,intr 0 0

```



