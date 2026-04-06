### deploy_diagnostics role to for deploy diagnostics policy, this is needed because the policy will deploy a diagnostic setting to send logs to log analytics workspace, and we need to assign the role to the policy identity so it has permissions to do that

data "azurerm_log_analytics_workspace" "central" {  
  for_each = var.workspaces_config

  name                = each.value.workspace_name
  resource_group_name = each.value.resource_group_name
}


resource "azurerm_role_assignment" "policy_to_workspace" {
  for_each = data.azurerm_log_analytics_workspace.central

  scope = data.azurerm_log_analytics_workspace.central[each.key].id

  role_definition_name = data.azurerm_log_analytics_workspace.central[each.key].name == "log-central" ?  "Log Analytics Contributor" : "Reader"

  principal_id = var.log_analytics_role_config.principal_id
}

