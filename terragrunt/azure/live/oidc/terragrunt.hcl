include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../modules/terraform_azure_oidc"
}

locals {
  mg_policy_scope = "/providers/Microsoft.Management/managementGroups/nunu_mg_root"
}

inputs = {
  azure_oidc_config = {
    mgmt = {
      issuer_url = "https://token.actions.githubusercontent.com"
      subject    = "repo:Nunu86/azure-lz:ref:refs/heads/main"
      audiences  = ["api://AzureADTokenExchange"]

      role_assignments = [
        {
          role_definition_name = "Management Group Contributor"
          scope                = local.mg_policy_scope
        },
        {
          role_definition_name = "Contributor"
          scope                = local.mg_policy_scope
        },
        {
          role_definition_name = "User Access Administrator"
          scope                = local.mg_policy_scope
        },
        {
          role_definition_name = "Storage Blob Data Contributor"
          scope = "/subscriptions/${include.root.locals.remote_state_subscription.id}/resourceGroups/terraform-state-backend/providers/Microsoft.Storage/storageAccounts/terraformstatebacken"
        }
      ]
    },

    mgmt2 = {
      issuer_url = "https://token.actions.githubusercontent.com"
      subject    = "repo:Nunu86/azure-lz:pull_request"
      audiences  = ["api://AzureADTokenExchange"]

      role_assignments = [
        {
          role_definition_name = "Management Group Contributor"
          scope                = local.mg_policy_scope
        },
        {
          role_definition_name = "Contributor"
          scope                = local.mg_policy_scope
        },
        {
          role_definition_name = "User Access Administrator"
          scope                = local.mg_policy_scope
        },
        {
          role_definition_name = "Storage Blob Data Contributor"
          scope = "/subscriptions/${include.root.locals.remote_state_subscription.id}/resourceGroups/terraform-state-backend/providers/Microsoft.Storage/storageAccounts/terraformstatebacken"
        }
      ]
    }
  }
}