data "azurerm_client_config" "current" {}

locals {
  

  tenant_root_short_id = data.azurerm_client_config.current.tenant_id

  mg_config = {
    for k, v in var.mg_config :
    k => {
        name         = v.name
        display_name = v.display_name

      parent_mg_id = (
        v.parent_mg_id != "" ?
          "${v.parent_mg_id}" :
          "/providers/Microsoft.Management/managementGroups/${local.tenant_root_short_id}"
      )
    }
  }
}



resource "azurerm_management_group" "az_mg" {
  for_each = local.mg_config

  name                      = each.value.name
  display_name              = each.value.display_name
  parent_management_group_id = each.value.parent_mg_id 
 
}


