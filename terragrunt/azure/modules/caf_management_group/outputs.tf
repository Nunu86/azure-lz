
output "mg_ids" {
  value = { for k, mg in azurerm_management_group.az_mg : k => mg.id }
}

output "mg_names" {
  value = { for k, mg in azurerm_management_group.az_mg : k => mg.name }
}