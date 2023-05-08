// main.bicep
param location string = 'centralus'
param vmSize string = 'Standard_D2s_v3'
param adminUsername string

@secure()
param adminPublicKey string

param scriptUri string
param scriptFileName string

module publicIP 'modules/public-ip.bicep' = {
  name: 'publicIP'
  params: {
    location: location
  }
}

module vnetNSG 'modules/vnet-nsg.bicep' = {
  name: 'vnetNSG'
  params: {
    location: location
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vm'
  params: {
    location: location
    vmSize: vmSize
    adminUsername: adminUsername
    adminPublicKey: adminPublicKey
    vnetId: vnetNSG.outputs.vnetId
    nsgId: vnetNSG.outputs.nsgId
    publicIPId: publicIP.outputs.publicIPId
    scriptUri: scriptUri
    scriptFileName: scriptFileName
  }
}
