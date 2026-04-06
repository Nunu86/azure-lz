



#log analytics workspace for centralised logging and monitoring of the landing zones, this is where we will send diagnostics logs to from the built in policies and any custom policies we create for monitoring and security, this is also where we will send logs from azure sentinel if we decide to use it in the future, we are creating this in a separate resource group to allow for better access control and to allow for the possibility of having different log analytics workspaces for different environments or workloads in the future if needed

#apply this first then you can apply deploy diagnostics policy cos it is dependent on this workspace then after applying the policy you can apply the data block here as well as the role
resource "azurerm_log_analytics_workspace" "central" { 
  for_each = var.workspaces_config     
  name                = each.value.workspace_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = each.value.retention_in_days
  tags       = each.value.tags
}

/*
resource "azurerm_role_assignment" "policy_to_workspace" {
  for_each = azurerm_log_analytics_workspace.central

  scope                = each.value.id
  role_definition_name = each.value.workspace_name == "log-central" ? "Log Analytics Contributor" : "Reader"  # assign Log Analytics Contributor role for central workspace and Reader role for any other workspaces, you can adjust this logic as needed based on your requirements
  principal_id         = var.principal_id # this should be the object id of the managed identity or service principal that needs access to the workspace, you can pass this in as a variable or look it up using a data source depending on your use case
}
*/

