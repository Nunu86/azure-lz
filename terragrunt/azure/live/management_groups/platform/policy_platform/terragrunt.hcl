include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../modules/policy_core"
}

dependency "mg" {
  config_path = "../../platform"
}

dependency "monitoring" {
  config_path = "../../../subs/dev/res-group/shared/monitoring"
}

inputs = {  

policy_initiative = {
    
  name                = "Platform-Guardrails"
  display_name        = "Platform Guardrails Initiative"
  category            = "Governance"
  version             = "1.0.0"
  management_group_id = dependency.mg.outputs.mg_ids["platform"]

  policy_refs = [
    "deploy_diagnostics",   ##must match the ref name in the module local.built_in_policy_guids map for built in policies, for custom policies it must match the key in the policy_definitions map
    #"mcsb"
  ]
  
  parameters_per_policy = {
  deploy_diagnostics = jsonencode({
     effect = {
      value = "audit"
    },
     log_analytics = {
      value = dependency.monitoring.outputs.log_analytics_id
    }
  })
    
  }
}

  
}

  
  policy_assignments = {    

    platform = {
      name                  = "alz-platform"
      display_name          = "Platform Guardrails"
      policy_definition_ref = "platform_guardrails"
      management_group_id   = dependency.mg.outputs.mg_ids["platform"]
      parameters            = null
    }

    
  }


/*

*/