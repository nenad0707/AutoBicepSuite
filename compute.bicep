@description('Location for the resources')
param location string

@description('Tags for all resources')
param tags object = {}

@minLength(3)
@maxLength(24)
@description('The name of the storage account')
param storageAccountName string

@description('The name of our function app resource')
param functionAppName string

@description('The name of the app service plan resource')
param appServicePlanName string

@description('The name of the application insights resource')
param applicationInsightsName string

@allowed([
  'S1'
  'B1'
])
param appServicePlanSku string

@secure()
@description('API key for our really interesting API')
param apiKey string

module appServicePlan 'module/app-service-plan.bicep' = {
  name: 'deploy-${appServicePlanName}'
  params: {
    appServicePlanName: appServicePlanName
    location: location
    appServicePlanSku: appServicePlanSku
  }
}

module functionApp 'module/function-app.bicep' = {
  name: 'deploy-${functionAppName}'
  params: {
    appServicePlanName: appServicePlanName
    appSettings: [
      {
        name: 'ApiKey'
        value: apiKey
      }
    ]
    applicationInsightsName: applicationInsightsName
    functionAppName: functionAppName
    storageAccountName: storageAccountName
    location: location
    tags: tags
  }
  dependsOn: [
    appServicePlan
  ]
}

output appServicePlanName string = appServicePlan.outputs.appServicePlanName
output appServicePlanId string = appServicePlan.outputs.appServicePlanId
output functionAppName string = functionApp.outputs.functionAppName
output functionAppId string = functionApp.outputs.functionAppId
output appServiceDefaultHostName string = functionApp.outputs.appServiceDefaultHostName
