// main.bicep
param location string = resourceGroup().location
param vmSize string
param adminUsername string

@secure()
param adminPublicKey string

var uniqueId = uniqueString(resourceGroup().id)

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: 'wireguardPublicIP-${uniqueId}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

module vnetNSG 'modules/vnet-nsg.bicep' = {
  name: 'vnetNSG-${uniqueId}'
  params: {
    location: location
  }
}

module vm 'modules/vm.bicep' = {
  name: 'wireguardVM-${uniqueId}'
  params: {
    location: location
    vmSize: vmSize
    adminUsername: adminUsername
    adminPublicKey: adminPublicKey
    subnetId: vnetNSG.outputs.subnetId
    nsgId: vnetNSG.outputs.nsgId
    publicIPId: publicIP.id
  }
}
