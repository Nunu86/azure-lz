/*
output "azure_oidc_principals" {
  value       = { for k, v in azuread_service_principal.oidc : k => v.object_id }
  description = "SP object IDs for each OIDC identity"
}
*/

output "azure_oidc_principal" {
  value = azuread_service_principal.oidc.object_id
}