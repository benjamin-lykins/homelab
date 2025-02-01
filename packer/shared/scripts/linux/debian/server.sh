#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Update package list and upgrade all packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install essential packages
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt-get update && sudo apt-get install -y vault consul nomad -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"


# Copy the configuration files
sudo cp /tmp/nomad.hcl /etc/nomad.d/nomad.hcl
sudo cp /tmp/nomad.service /lib/systemd/system/nomad.service

# Enable Services
sudo systemctl enable nomad
sudo systemctl enable consul
sudo systemctl enable vault

# Print completion message
echo "Base setup completed successfully."

