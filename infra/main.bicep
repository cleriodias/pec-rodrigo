param appName string = 'PEC83'
param location string = 'Brazil South'
param appServicePlanId string = '/subscriptions/51242591-9d16-401e-91da-fd5b6083c135/resourceGroups/rg-pec-rodrigo/providers/Microsoft.Web/serverfarms/sp-rodrigo-pec'

resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    reserved: true
    clientCertEnabled: false
    clientCertMode: 'Optional'
    siteConfig: {
      linuxFxVersion: 'PHP|8.2'
      alwaysOn: false
      ftpsState: 'FtpsOnly'
    }
  }
}

resource webAppFtp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: webApp
  name: 'ftp'
  properties: {
    allow: false
  }
}

resource webAppScm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: webApp
  name: 'scm'
  properties: {
    allow: true
  }
}
