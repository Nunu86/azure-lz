locals {
  flattened_role_assignments = flatten([
    for app_key, app_cfg in var.azure_oidc_config : [
      for role_cfg in app_cfg.role_assignments : {
        key                = app_key
        role_definition_name = role_cfg.role_definition_name
        scope              = role_cfg.scope
      }
    ]
  ])

  
role_assignment_map = {
    for r in local.flattened_role_assignments :
    "${r.key}-${r.role_definition_name}-${replace(r.scope, "/", "_")}" => r
  }

}
#one service app
resource "azuread_application" "oidc" {
  #for_each = var.azure_oidc_config

  display_name = "azure-oidc-app"
  identifier_uris = []
  
}

/*
resource "azuread_service_principal" "oidc" {
  for_each = azuread_application.oidc
  client_id = each.value.client_id
}
*/
#one service principal
resource "azuread_service_principal" "oidc" {
  client_id = azuread_application.oidc.client_id
}

resource "azuread_application_federated_identity_credential" "oidc" {
  for_each              = var.azure_oidc_config

  #application_id = azuread_application.oidc[each.key].id
  application_id = azuread_application.oidc.id
  display_name          = "github-oidc-${each.key}"
  description           = "GitHub OIDC Federated identity"

  audiences = each.value.audiences
  issuer    = each.value.issuer_url
  subject   = each.value.subject
}
/*
resource "azurerm_role_assignment" "oidc" {
  for_each = local.role_assignment_map

  scope              = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id       = azuread_service_principal.oidc[each.value.key].object_id
}
*/

resource "azurerm_role_assignment" "oidc" {
  for_each = local.role_assignment_map

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name

  principal_id = azuread_service_principal.oidc.object_id
}

#test