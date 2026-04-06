### Remember, i changed provider version to acomodate policy exclusion block
data "azurerm_policy_definition" "built_in" {
  for_each = local.built_in_policy_guids
  name     = each.value
}

locals {
  built_in_policy_guids = {
    allowed_locations = "e56962a6-4747-49cd-b67b-bf8b01975c4c"     #  allowed_locations is the name of the built in policy we dont use name as variable here because we want to be able to identify other built in policies by their ref name in the initiative policy_refs list, and the value is the guid of the built in policy which we need to look up the id for assignment and initiative references
    deploy_diagnostics = "0120ef84-66e7-4faf-aad8-14c36389697e "   # deploy_diagnostics is the name of the built in policy we dont use name as variable here because we want to be able to identify other built in policies by their ref name in the initiative policy_refs list, and the value is the guid of the built in policy which we need to look up the id for assignment and initiative references
    #mcsb               = "058e9719-1ff9-3653-4230-23f76b6492e0"
    #log_analytics_workspace = "087dbf66-448d-4235-b7b8-17af48edc9db"
    #security_alerts   ="171e377b-5224-4a97-1eaa-62a3b5231dac"
    #notify_failed_security_events = "18e9d748-73d4-0c96-55ab-b108bfbd5bc3"
    # add more here
  }
  built_in_policy_ids = {
    for k, v in data.azurerm_policy_definition.built_in :
    k => v.id
  }

  custom_policy_ids = {
    for k, v in azurerm_policy_definition.custom :
    k => v.id
  }

  
  

  initiative_id = azurerm_policy_set_definition.initiative.id
  #initiative_name = azurerm_policy_set_definition.initiative.name


   
}

/*
locals {
  org     = "alz"
  version = "v1"

  naming = {
    root        = "${local.org}-root-${local.version}"
    platform    = "${local.org}-platform-${local.version}"
    landingzone = "${local.org}-lz-${local.version}"
  }
}
*/


 

########################################
# Custom policy definitions
########################################


resource "azurerm_policy_definition" "custom" {
  for_each = var.policy_definitions

  name                = each.value.name
  display_name        = each.value.display_name
  policy_type         = "Custom"
  mode                = each.value.mode
  management_group_id = each.value.management_group_id

  metadata   = jsonencode(each.value.metadata) 
 
  parameters = each.value.parameters != null ? jsonencode(each.value.parameters) : null
  policy_rule = each.value.policy_rule != null ? jsonencode(each.value.policy_rule) : null
  #what if im using policy rule path

  
}

########################################
# Policy initiatives
########################################

resource "azurerm_policy_set_definition" "initiative" {
  name                = var.policy_initiative.name
  description         = "Policy initiative created by Terraform"
  display_name        = var.policy_initiative.display_name
  policy_type         = "Custom"
  management_group_id = var.policy_initiative.management_group_id

  metadata = jsonencode({
    category = var.policy_initiative.category
    updatedBy = "Terraform"
    updatedOn = timestamp()
    
  })

  dynamic "policy_definition_reference" {
    for_each = var.policy_initiative.policy_refs
    content {
      policy_definition_id = try(
        local.built_in_policy_ids[policy_definition_reference.value], #you have mapped policy_definition_ids to local.built_in_policy_ids, which resolves each eg allowed_locations = /subscriptions/xxx/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c, you now need to resolve same for each var.policy_initiative.policy_refs, which is a list of keys eg ["allowed_locations", "enforce_default_tags"], so you can do local.built_in_policy_ids[policy_definition_reference.value] to get the id for each ref, and if not found then try local.custom_policy_ids[policy_definition_reference.value] to check if it's a custom policy ref
        local.custom_policy_ids[policy_definition_reference.value]
      )     

    parameter_values = try(
      var.policy_initiative.parameters_per_policy[policy_definition_reference.value],
      null
    )

    reference_id = policy_definition_reference.value
  }
  }
}

########################################
# Policy assignments
########################################



resource "azurerm_management_group_policy_assignment" "assignments" {
  for_each = var.policy_assignments

  #name                 = "${local.naming[each.value.scope]}-assignment"
  name             = each.value.name
  display_name         = each.value.display_name
  management_group_id  = each.value.management_group_id

  policy_definition_id = try(
  local.initiative_id,
  local.built_in_policy_ids[each.value.policy_definition_ref],
  local.custom_policy_ids[each.value.policy_definition_ref]
)


  parameters = jsonencode(each.value.parameters)

  dynamic "identity" {
    for_each = each.value.identity_required ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}



resource "azurerm_resource_policy_exemption" "exemptions" {
  for_each = var.policy_exemptions

  name                 = each.value.name
  resource_id          = each.value.resource_id
  policy_assignment_id = each.value.policy_assignment_id
  exemption_category   = each.value.exemption_category
  display_name         = each.value.display_name
  description          = each.value.description
}
  