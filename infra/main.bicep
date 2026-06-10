// Azure Advisor remediation (assumed): Harden Storage Account security settings
// Target: webassets-prod in resource group web-prod-rg
// This template enforces:
// - HTTPS only (supportsHttpsTrafficOnly)
// - Minimum TLS version 1.2
// - Disable public blob access (allowBlobPublicAccess)
//
// Note: Subscription and resource group are deployment scope concerns; deploy this template
// in each subscription (2fa761b0-056f-43b8-8eba-2677199dfb9d and 84ca48fe-c942-42e5-b492-d56681d058fa)
// to the resource group 'web-prod-rg'.

targetScope = 'resourceGroup'

@description('Name of the existing storage account to harden.')
param storageAccountName string = 'webassets-prod'

@description('Location of the existing storage account. Used for the resource declaration.')
param location string

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  // Using an existing resource declaration so we can update properties safely.
  existing: true
}

// Patch/update the existing storage account with secure settings.
resource storageUpdate 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storage.name
  location: location
  kind: storage.kind
  sku: {
    name: storage.sku.name
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}
