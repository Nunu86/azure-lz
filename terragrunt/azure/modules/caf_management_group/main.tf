data "azurerm_client_config" "current" {}

locals {
  

  tenant_root_short_id = data.azurerm_client_config.current.tenant_id

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

data "azurerm_policy_set_definition" "security_baseline" {
  name = "AzureSecurityBenchmark"
}


#applies guardrails to the landingzone management group. This is just an example, you can assign any policy or initiative to the management group as needed. You can also assign policies at the subscription level if needed.
resource "azurerm_management_group_policy_assignment" "security_baseline" {
  for_each = var.mg_config
  name                 = "security-baseline-${each.value.name}"
  policy_definition_id = data.azurerm_policy_set_definition.security_baseline.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/${each.value.name}"
}

resource "azurerm_policy_definition" "enforce_tags" {
  name         = "enforce-default-tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce default tags on all resources"

  metadata = jsonencode({
    version  = "1.0.0"
    category = "Tags"
  })

  policy_rule = jsonencode({
    if = {
      field  = "tags"
      exists = "false"
    }
    then = {
      effect  = "append"
      details = {
        tags = "[parameters('tags')]"
      }
    }
  })

  parameters = jsonencode({
    tags = {
      type = "Object"
      metadata = {
        displayName = "Default Tags"
        description = "Tags to append to all resources"
      }
    }
  })
}
/*
resource "azurerm_resource_policy_assignment" "default_tags" {
  for_each             = var.mg_config

  name                 = "default-tags-${each.key}"
  display_name         = "Default Tags for ${each.value.display_name}"
  description          = "Applies default tags to all resources in ${each.value.display_name}"
  resource_id                = "/providers/Microsoft.Management/managementGroups/${each.key}"
  policy_definition_id = azurerm_policy_definition.enforce_tags.id

  parameters = jsonencode({
    tags = {
      value = each.value.default_tags
    }
  })
}
*/

resource "azurerm_management_group_policy_assignment" "default_tags" {
  for_each = var.mg_config

  name         = "tags-${substr(each.value.name, 0, 10)}"
  display_name = "Default Tags for ${each.value.display_name}"
  description  = "Applies default tags to all resources in ${each.value.display_name}"

  management_group_id = "/providers/Microsoft.Management/managementGroups/${each.value.name}"
  policy_definition_id = azurerm_policy_definition.enforce_tags.id

  parameters = jsonencode({
    tags = {
      value = each.value.default_tags
    }
  })
}

