// Azure Advisor remediation: harden Storage Account security settings
// Target: webassets-prod (Microsoft.Storage/storageAccounts)
// - Enforce HTTPS-only traffic
// - Require minimum TLS 1.2
// - Disable public blob access

targetScope = 'resourceGroup'

@description('Name of the Storage Account to configure')
param storageAccountName string = 'webassets-prod'

@description('Azure region for the Storage Account (must match existing if already deployed)')
param location string = resourceGroup().location

// NOTE:
// If the storage account already exists and is managed outside this template,
// deploying this file may attempt to create it. Prefer importing into IaC or
// aligning with your existing deployment structure.
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}
