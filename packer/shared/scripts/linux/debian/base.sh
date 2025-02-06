#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Update package list and upgrade all packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Java installation
sudo apt-get -y install default-jdk curl

# Install Instana Agent
curl -o setup_agent.sh https://setup.instana.io/agent && chmod 700 ./setup_agent.sh && sudo ./setup_agent.sh -a oZfwHK8WSVe7AdjjNwUk9A -d oZfwHK8WSVe7AdjjNwUk9A -t dynamic -e ingress-red-saas.instana.io:443  -y -s

# Print completion message
echo "Base setup completed successfully."
