
# Move subscription into management group
resource "azurerm_management_group_subscription_association" "sub_in_mg" {
  for_each = var.sub_config

  subscription_id      = "/subscriptions/${each.value.subscription_id}"
  management_group_id  = "/providers/Microsoft.Management/managementGroups/${each.value.management_group_name}"
}

/*
#policies to be assigned at subscription level
resource "azurerm_security_center_subscription_pricing" "defender_vm" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_storage" {
  tier          = "Standard"
  resource_type = "StorageAccounts"
}
*/

