#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Update package list and upgrade all packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Hashicorp packages
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt-get update && sudo apt-get install -y vault consul nomad nomad-driver-podman nomad-driver-exec2 -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Docker installation
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Podman installation
sudo apt-get -y install podman

# Java installation
sudo apt-get -y install default-jdk

# Mount NFS Share
sudo apt-get -y install nfs-common
sudo mkdir -p /nfs/general
sudo mount 192.168.39.132:/var/nfs/general /nfs/general
echo "192.168.39.132:/var/nfs/general /nfs/general nfs defaults 0 0" | sudo tee -a /etc/fstab


# Copy the configuration files
sudo cp /tmp/client.nomad.hcl /etc/nomad.d/nomad.hcl
sudo cp /tmp/nomad.service /lib/systemd/system/nomad.service


# Enable Services
sudo systemctl enable nomad
sudo systemctl enable consul
sudo systemctl enable vault


# Print completion message
echo "Client setup completed successfully."
