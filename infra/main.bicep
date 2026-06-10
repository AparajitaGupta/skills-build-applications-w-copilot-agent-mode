// Azure Advisor remediation (assumed): Harden Storage Account security settings
// - Enforce HTTPS-only traffic
// - Disable public blob access
// - Require minimum TLS 1.2
//
// Target resource(s):
// /subscriptions/a1b2c3d4-1111-4f8a-9c2e-0123456789ab/resourceGroups/web-prod-rg/providers/Microsoft.Storage/storageAccounts/webassets-prod
// /subscriptions/b2c3d4e5-2222-4a9b-8d3f-123456789abc/resourceGroups/web-prod-rg/providers/Microsoft.Storage/storageAccounts/webassets-prod

targetScope = 'subscription'

@description('Deployment location for subscription-scoped resources (used for the RG module).')
param location string = 'eastus'

@description('The resource group containing the storage account.')
param resourceGroupName string = 'web-prod-rg'

@description('Storage account name to remediate.')
param storageAccountName string = 'webassets-prod'

@description('Storage account SKU.')
param skuName string = 'Standard_LRS'

@description('Storage account kind.')
param kind string = 'StorageV2'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroupName
}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  scope: rg
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  properties: {
    // Advisor hardening
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false

    // Reasonable defaults
    accessTier: 'Hot'
  }
}
