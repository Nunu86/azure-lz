resource "azurerm_resource_group" "rg" {
  for_each = var.rg_config
  name     = var.rg_config[each.key].name
  location = var.rg_config[each.key].location
  tags     = var.rg_config[each.key].tags
}
