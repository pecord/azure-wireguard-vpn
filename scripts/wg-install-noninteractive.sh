#!/bin/bash

set -eou pipefail

echo "Download the PiVPN non-interactive installation script"
curl -L https://install.pivpn.io -o install_pivpn.sh
chmod +x install_pivpn.sh

echo "Download the specified WireGuard configuration"
curl -L https://raw.githubusercontent.com/pecord/azure-wireguard-vpn/main/scripts/wireguard.conf -o wireguard.conf

echo "Replace the placeholder with the public IP address of the VM"
sed -i 's/pivpn.example.com/$(curl -s ifconfig.me)/g' wireguard.conf

echo "Run the PiVPN installation script with the specified configuration"
sudo ./install_pivpn.sh --unattended wireguard.conf

echo "Generate WireGuard clients and output their profiles"
num_clients=3
for i in $(seq 1 $num_clients); do
  sudo pivpn -a -n "client$i"
done