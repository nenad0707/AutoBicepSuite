@description('Location for the resources')
param location string

@description('Tags for all resources')
param tags object = {}

@description('The name of our function app resource')
param functionAppName string

@description('The name of the app service plan resource')
param appServicePlanName string

@description('The name of the application insights resource')
param applicationInsightsName string

@description('App settings for the function app')
param appSettings array

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' existing = {
  name: appServicePlanName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

var requiredAppSettings = [
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: appInsights.properties.InstrumentationKey
  }
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: appInsights.properties.ConnectionString
  }
  {
    name: 'FUNCTIONS_EXTENSION_VERSION'
    value: '~4'
  }
  {
    name: 'FUNCTIONS_WORKER_RUNTIME'
    value: 'dotnet'
  }
]

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      windowsFxVersion: 'DOTNETCORE|LTS'
      alwaysOn: true
      appSettings: union(appSettings, requiredAppSettings)
    }
  }
  dependsOn: [
    appServicePlan
  ]
}

output functionAppName string = functionApp.name
output functionAppId string = functionApp.id
