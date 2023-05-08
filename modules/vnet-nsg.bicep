// vnet-nsg.bicep
param location string

var uniqueId = uniqueString(resourceGroup().id)

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: 'wireguardVNet-${uniqueId}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'wireguardSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: 'wireguardNSG-${uniqueId}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'WireGuard_UDP_Rule'
        properties: {
          priority: 100
          protocol: 'Udp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '51820'
        }
      }, {
        name: 'SSH_Rule'
        properties: {
          priority: 110
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

output nsgId string = nsg.id
output subnetId string = vnet.properties.subnets[0].id
