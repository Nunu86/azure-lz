locals {
  tenant_root_short_id = "00000000-0000-0000-0000-000000000000"

  mg_config = {
    for k, v in var.mg_config :
    k => {
      name         = v.name
      display_name = v.display_name

      parent_id = (
        v.parent_mg_id != "" ?
          "/providers/Microsoft.Management/managementGroups/${v.parent_mg_id}" :
          "/providers/Microsoft.Management/managementGroups/${local.tenant_root_short_id}"
      )
    }
  }
}


resource "azurerm_management_group" "az_mg" {
  for_each = local.mg_config

  name                      = each.value.name
  display_name              = each.value.display_name
  parent_management_group_id = each.value.parent_id
}

/*
#applies guardrails to the landingzone management group. This is just an example, you can assign any policy or initiative to the management group as needed. You can also assign policies at the subscription level if needed.
resource "azurerm_management_group_policy_assignment" "security_baseline" {
  name                 = "security-baseline"
  policy_definition_id = data.azurerm_policy_set_definition.security_baseline.id
  management_group_id  = azurerm_management_group.landingzones.id
}
*/