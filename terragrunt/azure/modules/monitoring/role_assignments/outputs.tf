output "role_assignment_ids" {
    value = {
  for k, v in azurerm_role_assignment.policy_to_workspace :
  k => v.id
}
}