// vm.bicep
param location string
param vmSize string
param adminUsername string
param subnetId string
param nsgId string
param publicIPId string

@secure()
param adminPublicKey string

var uniqueId = uniqueString(resourceGroup().id)
var vmName = 'wireguardVM-${uniqueId}'

resource nic 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: 'wireguardNIC-${uniqueId}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-${uniqueId}'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.1.4'
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIPId
          }
        }
      }
    ]
    enableAcceleratedNetworking: true // Enable Accelerated Networking
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: vm
  name: 'customScript-${uniqueId}'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'curl https://raw.githubusercontent.com/pecord/azure-wireguard-vpn/main/scripts/init.sh | sudo bash'
    }
  }
}
