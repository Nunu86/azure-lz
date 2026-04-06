output "name" {
  value = {
    for k, v in azurerm_resource_group.rg :
    k => v.name
  }
}

output "id" {
  value = {
    for k, v in azurerm_resource_group.rg :
    k => v.id
  }
}