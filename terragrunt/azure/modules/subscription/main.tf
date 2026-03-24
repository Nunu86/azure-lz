resource "azurerm_management_group_subscription_association" "mg_assign" {
  management_group_id = var.sub_config.management_group_id
  subscription_id     = var.sub_config.subscription_id
}



