#!/bin/bash

#debug
set -exou pipefail

echo "install unbound"
apt install unbound -y
curl -L https://raw.githubusercontent.com/pecord/azure-wireguard-vpn/main/scripts/unbound.conf -o ./unbound.conf
mkdir -p /etc/unbound/unbound.conf.d/
mv ./unbound.conf /etc/unbound/unbound.conf.d/pi-hole.conf

echo "restart unbound"
service unbound restart

echo "test unbound"
dig pi-hole.net @127.0.0.1 -p 5335