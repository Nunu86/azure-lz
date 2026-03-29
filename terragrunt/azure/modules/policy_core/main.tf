resource "azurerm_policy_definition" "enforce_tags" {
  for_each = var.policy_definitions

  name         = each.value.name
  display_name = each.value.display_name
  policy_type  = each.value.policy_type
  mode         = each.value.mode
  metadata     = jsonencode(each.value.metadata)
  policy_rule  = file("${path.module}/policies/enforce_tags.json")
  parameters   = jsonencode(each.value.parameters) 
  management_group_id = each.value.management_group_id

}


resource "azurerm_management_group_policy_assignment" "policy_assignments" {
  for_each = var.policy_assignments

  name                 = each.value.name
  display_name         = each.value.display_name  
  management_group_id   =  each.value.management_group_id
  policy_definition_id = azurerm_policy_definition.enforce_tags[each.value.policy_definition_ref].id
  parameters           = jsonencode(each.value.parameters) 
}
