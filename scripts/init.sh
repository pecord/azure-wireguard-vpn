#!/bin/bash

set -eou pipefail

echo "Set the environment variable to non-interactive"
export DEBIAN_FRONTEND="noninteractive"
export USER="$(whoami)"

echo "update the system"
apt update -y && apt upgrade -y

# nessasry else we see errors like - 
# sudo: unable to resolve host $HOSTNAME: No address associated with hostname
echo "Add computer hostname to /etc/hosts"
echo "127.0.0.1 $HOSTNAME" | tee -a /etc/hosts

echo "Download and install unbound non-interactive installation script"
curl -L https://raw.githubusercontent.com/pecord/azure-wireguard-vpn/main/scripts/unbound-install-noninteractive.sh -o unbound-install-noninteractive.sh
chmod +x unbound-install-noninteractive.sh
sudo ./unbound-install-noninteractive.sh

echo "Download and install Pi-Hole non-interactive installation script"
curl -L https://raw.githubusercontent.com/pecord/azure-wireguard-vpn/main/scripts/pi-hole-install-noninteractive.sh -o pi-hole-install-noninteractive.sh
chmod +x pi-hole-install-noninteractive.sh
sudo ./pi-hole-install-noninteractive.sh

echo "Download and installl the PiVPN non-interactive installation script"
curl -L https://raw.githubusercontent.com/pecord/azure-wireguard-vpn/main/scripts/wg-install-noninteractive.sh -o wg-install-noninteractive.sh
chmod +x wg-install-noninteractive.sh
sudo ./wg-install-noninteractive.sh