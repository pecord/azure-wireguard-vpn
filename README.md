# Azure WireGuard VPN Deployment

This repository contains the necessary files to deploy a WireGuard VPN server on an Azure virtual machine using Bicep templates and a custom script for installing and configuring PiVPN.

## Prerequisites

1. Azure CLI installed on your local machine (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. An active Azure subscription
3. VSCode installed on your local machine
4. Bicep and Azure extensions installed for VSCode

## Deployment Steps

1. Clone this repository:

   ```
   git clone https://github.com/pecord/azure-wireguard-vpn.git
   cd azure-wireguard-vpn
   ```

2. Open the repo in VSCode
3. right click on the main.bicep file and click "Deploy Bicep file", it will prompt you a couple of times for parameters
4. Should see a successful deployment after that you should be able to SSH into the public IP of the VM
5. After I ssh in I run `pivpn -qr` to get a QR code for the Wireguard profile
6. After I import the wireguard profile I have to change the endpoint to the public ip and I am able to connect 

License

This project is licensed under the MIT License. See the LICENSE file for details.

## TODO
1. make it more idempotent 
   - make it use a static public ip
   - make it so it doesn't trample over existing configs on a re-deploy