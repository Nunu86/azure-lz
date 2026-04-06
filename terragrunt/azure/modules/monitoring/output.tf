output "workspace_id" {
  value = {
    for k, v in azurerm_log_analytics_workspace.central :
    k => v.id
  }
}

output "workspace_name" {
  value = { for k, v in azurerm_log_analytics_workspace.central : k => v.name }
}
 