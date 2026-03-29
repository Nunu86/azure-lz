resource "azurerm_resource_group" "rg" {
  name     = var.rg_config.name
  location = var.rg_config.location
  tags     = var.rg_config.tags
}
