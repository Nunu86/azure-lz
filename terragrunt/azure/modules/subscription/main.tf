/*
resource "azurerm_management_group_subscription_association" "mg_assign" {
  management_group_id = var.sub_config.management_group_id
  subscription_id     = var.sub_config.subscription_id
}
*/


# Existing Management Group


# Move subscription into management group
resource "azurerm_management_group_subscription_association" "sub_in_mg" {
  for_each = var.sub_config

  subscription_id      = "/subscriptions/${each.value.subscription_id}"
  management_group_id  = "/providers/Microsoft.Management/managementGroups/${each.value.management_group_name}"
}


