// Bicep: Azure Advisor remediation (assumed) for Storage Account hardening
// Targets: webassets-prod in web-prod-rg (two subscriptions)
// Changes: enforce HTTPS-only, disable public blob access, require TLS 1.2+

targetScope = 'subscription'

@description('Subscription ID to deploy into. Deploy once per subscription.')
param subscriptionId string

@description('Resource group containing the storage account.')
param resourceGroupName string = 'web-prod-rg'

@description('Storage account name to harden.')
param storageAccountName string = 'webassets-prod'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroupName
  scope: subscription(subscriptionId)
}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  scope: rg
  // NOTE: This template assumes the storage account already exists and updates settings.
  // If it does not exist, add required properties like location, sku, kind, etc.
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}
