@description('Required. The name of the virtual WAN to create')
param virtualWANName string

@description('Optional. The location to deploy to')
param location string = resourceGroup().location

resource virtualWan 'Microsoft.Network/virtualWans@2021-05-01' = {
  name: virtualWANName
  location: location
}

@description('The principal of the created managed identity')
output virtualWWANResourceId string = virtualWan.id
