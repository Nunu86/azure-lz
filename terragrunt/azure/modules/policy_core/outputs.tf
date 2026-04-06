output "policy_assignments" {
  value = {
    for k, v in azurerm_management_group_policy_assignment.assignments :
    k => v.id
  }
}

output "policy_assignment_principal_ids" {
  value = {
    for k, v in azurerm_management_group_policy_assignment.assignments :
    k => v.identity[0].principal_id
  }
}


