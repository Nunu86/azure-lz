resource "azurerm_resource_group" "rg" {
  for_each = var.resource_group
  name     = var.rg_config[each.key].name
  location = var.rg_config[each.key].location
  tags     = var.rg_config[each.key].tags
}
