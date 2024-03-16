@description('Location for the resources')
param location string = resourceGroup().location

@description('Tags for all resources')
param tags object = {}

@minLength(3)
@maxLength(24)
@description('The name of the storage account')
param storageAccountName string

@minLength(3)
@maxLength(24)
@description('The name of the SFTP storage account')
param sftpStorageAccountName string

@description('The name of the application insights')
param applicationInsightsName string

@description('The name of the app service plan')
param appServicePlanName string

@description('Name of the SKU')
@allowed([
  'Standard_GRS'
  'Standard_LRS'
])
param storageAccountSku string = 'Standard_LRS'

@allowed([
  'S1'
  'B1'
  'F1'
])
param appSevicePlanSku string = 'F1'

module storageAccount 'module/storage-account.bicep' = {
  name: 'deploy-${sftpStorageAccountName}'
  params: {
    location: location
    tags: tags
    storageAccountName: sftpStorageAccountName
    storageAccountSku: storageAccountSku
    isSftpEnabled: true
  }
}

module sftpStorageAccount 'module/storage-account.bicep' = {
  name: 'deploy-sftp-${storageAccountName}'
  params: {
    location: location
    tags: tags
    storageAccountName: storageAccountName
  }
}

module applicationInsights 'module/application-insight.bicep' = {
  name: 'deploy-${applicationInsightsName}'
  params: {
    location: location
    applicationInsightsName: applicationInsightsName
  }
}

module appServicePlan 'module/app-service-plan.bicep' = {
  name: 'deploy-${appServicePlanName}'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    appSevicePlanSku: appSevicePlanSku
  }
}

output storageAccountName string = storageAccount.outputs.storageAccountName
output applicationInsightsName string = applicationInsights.outputs.applicationInsightsName
output appServicePlanName string = appServicePlan.outputs.appServicePlanName
