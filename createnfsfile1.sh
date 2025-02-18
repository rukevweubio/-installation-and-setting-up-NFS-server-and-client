#!/usr/bin/bash

# Update the Linux machine
echo "Updating the Linux machine..."
sudo apt update -y && sudo apt upgrade -y

# Install NFS kernel server
echo "Installing NFS kernel server..."
sudo apt install nfs-kernel-server -y

# Start and enable the NFS service
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server

# Create the NFS share directory
SHARE_DIR="/home/nfssystem"
MOUNT_DIR="/mnt/nfssystem"

# Check if the share directory exists; create it if it doesn't
if [ ! -d "$SHARE_DIR" ]; then
    echo "Creating the NFS share directory: $SHARE_DIR"
    sudo mkdir -p "$SHARE_DIR"
    sudo chmod 777 "$SHARE_DIR"
    sudo chown nobody:nogroup "$SHARE_DIR"
else
    echo "NFS share directory already exists: $SHARE_DIR"
fi

# Create the mount directory for clients
if [ ! -d "$MOUNT_DIR" ]; then
    echo "Creating the NFS mount directory: $MOUNT_DIR"
    sudo mkdir -p "$MOUNT_DIR"
    sudo chmod 777 "$MOUNT_DIR"
    sudo chown nobody:nogroup "$MOUNT_DIR"
else
    echo "NFS mount directory already exists: $MOUNT_DIR"
fi

# Configure the NFS exports file
EXPORTS_FILE="/etc/exports"
CLIENT_IP="172.17.18.50"

# Check if the exports file exists
if [ -f "$EXPORTS_FILE" ]; then
    # Add the NFS share configuration to the exports file
    echo "Configuring the NFS exports file..."
    echo "$SHARE_DIR $CLIENT_IP(rw,sync,no_subtree_check)" | sudo tee -a "$EXPORTS_FILE" > /dev/null
else
    echo "Error: The exports file does not exist!"
    exit 1
fi

# Export the NFS shares
echo "Exporting NFS shares..."
sudo exportfs -a

# Verify the exported shares
echo "Verifying exported shares..."
sudo exportfs -v

# Show mounted directories on localhost
echo "Showing mounted directories on localhost..."
showmount -e localhost

# Mount the NFS share on the client side (optional)
echo "Mounting the NFS share on the client..."
if ! sudo mount -t nfs "$CLIENT_IP:$SHARE_DIR" "$MOUNT_DIR"; then
    echo "Failed to mount the NFS share!"
    exit 1
else
    echo "NFS share successfully mounted at $MOUNT_DIR"
fi

# Save the disk usage report to a file
echo "Saving disk usage report to mountfile.txt..."
df -h > mountfile.txt 2>&1

# Display completion message
echo "NFS setup completed successfully."
