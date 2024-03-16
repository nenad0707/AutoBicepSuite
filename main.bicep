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

@description('Name of the SKU')
@allowed([
  'Standard_GRS'
  'Standard_LRS'
])
param storageAccountSku string = 'Standard_LRS'

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

output storageAccountName string = storageAccount.outputs.storageAccountName
