#!/bin/bash

#debug
set -exou pipefail

# Set the environment variable to non-interactive
export DEBIAN_FRONTEND=noninteractive

echo "Setup variables for pi-hole"
mkdir -p /etc/pihole/
curl -L https://raw.githubusercontent.com/pecord/azure-wireguard-vpn/main/scripts/pihole.conf -o ./pihole.conf
mv ./pihole.conf /etc/pihole/setupVars.conf

# Run the installer.
echo "Run the installer"
curl -L https://install.pi-hole.net -o pi-hole-setup.sh
chmod +x pi-hole-setup.sh 
bash ./pi-hole-setup.sh --unattended