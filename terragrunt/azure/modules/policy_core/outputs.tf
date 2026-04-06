output "policy_assignments" {
  value = {
    for k, v in azurerm_management_group_policy_assignment.assignments :
    k => v.id
  }
}
