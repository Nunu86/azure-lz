terraform {
  source = "../../../../modules/policy_core"
}

dependency "mg" {
  config_path = "../../landingzones"
}

inputs = {

  built_in_policies = {
    https_only     = "App Service apps should only be accessible over HTTPS"
    deny_public_ip = "Not allowed resource types"
  }

   policy_initiatives = {
    lz_guardrails = {
      name                = "alz-landingzones-v1"
      display_name        = "ALZ Landing Zone Guardrails"
      management_group_id = dependency.mg.outputs.mg_ids["landingzones"]
      category            = "Application"
      version             = "1.0.0"

      policy_refs = [
        "https_only",
        "deny_public_ip"
      ]
    }
  }

   policy_assignments = {
    lz = {
      name                  = "alz-landingzones"
      display_name          = "Landing Zone Guardrails"
      policy_definition_ref = "lz_guardrails"
      management_group_id   = dependency.mg.outputs.mg_ids["landingzones"]
    }
  }
/* Alternative approach with direct assignment of built-in policies without initiative
  policy_assignments = {

    https = {
      name                  = "https-only"
      display_name          = "Enforce HTTPS"
      policy_definition_ref = "https_only"
      management_group_id   = dependency.mg.outputs.mg_ids["landingzones"]
    }

    deny_ip = {
      name                  = "deny-public-ip"
      display_name          = "Deny Public IP"
      policy_definition_ref = "deny_public_ip"
      management_group_id   = dependency.mg.outputs.mg_ids["landingzones"]

      parameters = {
        listOfResourceTypesNotAllowed = {
          value = ["Microsoft.Network/publicIPAddresses"]
        }
      }
    }
  }
  */
}

