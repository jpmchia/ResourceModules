targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
@description('Required. The name prefix to inject into all resource names')
param namePrefix string

@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = '${serviceShort}-ms.network-vpnSites-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'vsimin'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'nestedTemplates/min.parameters.nested.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    virtualWANName: 'apd-${namePrefix}-az-vw-${serviceShort}-001'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-vpnSites-${serviceShort}'
  params: {
    name: '${namePrefix}-az-${serviceShort}-001'
    virtualWanId: resourceGroupResources.outputs.virtualWWANResourceId
  }
}
