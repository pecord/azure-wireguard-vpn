// public-ip.bicep
param location string

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: 'wireguardPublicIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

output publicIPId string = publicIP.id
