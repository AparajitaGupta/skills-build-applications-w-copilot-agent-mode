// Azure Storage Account hardening per Azure Advisor recommendation
// Target: /subscriptions/2fa761b0-056f-43b8-8eba-2677199dfb9d/resourceGroups/web-prod-rg/providers/Microsoft.Storage/storageAccounts/webassets-prod

@description('Azure region for the resources')
param location string = resourceGroup().location

@description('Storage account name')
param storageAccountName string = 'webassets-prod'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    // Advisor: Require secure transfer (HTTPS) for all requests
    supportsHttpsTrafficOnly: true

    // Advisor: Prevent anonymous/public access to blobs/containers
    allowBlobPublicAccess: false

    // Common hardening defaults
    minimumTlsVersion: 'TLS1_2'
    accessTier: 'Hot'
  }
}
