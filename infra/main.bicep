// Azure Storage Account hardening per Azure Advisor recommendation
// - Enforce HTTPS-only traffic
// - Disable public blob access
// - Require minimum TLS 1.2
//
// NOTE: This file is intentionally minimal and can be integrated into your existing IaC structure.

targetScope = 'resourceGroup'

@description('Name of the Storage Account to configure')
param storageAccountName string = 'webassets-prod'

@description('Location for the Storage Account (must match existing if already deployed)')
param location string = resourceGroup().location

@description('SKU for the Storage Account')
param skuName string = 'Standard_LRS'

@description('Kind for the Storage Account')
param kind string = 'StorageV2'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  properties: {
    // Advisor: Secure transfer should be enabled
    supportsHttpsTrafficOnly: true

    // Advisor: Prevent anonymous/public access to blobs/containers
    allowBlobPublicAccess: false

    // Advisor: Enforce modern TLS
    minimumTlsVersion: 'TLS1_2'
  }
}
