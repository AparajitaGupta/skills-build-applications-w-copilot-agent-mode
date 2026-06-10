// Bicep template to deploy/secure the webassets-prod Storage Account
// Azure Advisor hardening applied:
// - Enforce HTTPS-only traffic (supportsHttpsTrafficOnly)
// - Disable public blob access (allowBlobPublicAccess)

targetScope = 'resourceGroup'

@description('Name of the existing Storage Account to secure')
param storageAccountName string = 'webassets-prod'

@description('Location of the Storage Account (only required if deploying a new account)')
param location string = resourceGroup().location

// Reference the existing storage account so we can update its properties.
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

// Update the existing storage account with secure defaults.
resource storageAccountUpdate 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccount.name
  location: location
  kind: storageAccount.kind
  sku: {
    name: storageAccount.sku.name
  }
  properties: {
    // Advisor: Secure transfer should be enabled
    supportsHttpsTrafficOnly: true

    // Advisor: Prevent anonymous/public access to blobs/containers
    allowBlobPublicAccess: false

    // Keep current minimum TLS if already set; otherwise enforce TLS 1.2
    minimumTlsVersion: storageAccount.properties.minimumTlsVersion ?? 'TLS1_2'
  }
}
