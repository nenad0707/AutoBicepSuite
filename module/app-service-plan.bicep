@description('Location for the resources')
param location string

@description('Tags for all resources')
param tags object = {}

@allowed([
  'S1'
  'B1'
  'F1'
])
param appSevicePlanSku string = 'F1'

@description('The name of the app service plan')
param appServicePlanName string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: appSevicePlanSku
    tier: 'Basic'
  }
}

output appServicePlanName string = appServicePlan.name
output appServicePlanId string = appServicePlan.id
