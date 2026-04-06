

data "azurerm_policy_assignment" "deploy_diagnostics" {  
  name     = alz-platform
  scope    = var.management_group_id
}

#log analytics workspace for centralised logging and monitoring of the landing zones, this is where we will send diagnostics logs to from the built in policies and any custom policies we create for monitoring and security, this is also where we will send logs from azure sentinel if we decide to use it in the future, we are creating this in a separate resource group to allow for better access control and to allow for the possibility of having different log analytics workspaces for different environments or workloads in the future if needed
resource "azurerm_log_analytics_workspace" "central" {
  name                = "log-central"
  location            = "UK South"
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_role_assignment" "log_analytics_contributor" {
  scope                = var.log_analytics_workspace_id
  role_definition_name = "Monitoring Contributor"
  principal_id         = data.azurerm_policy_assignment.deploy_diagnostics.identity[0].principal_id
}