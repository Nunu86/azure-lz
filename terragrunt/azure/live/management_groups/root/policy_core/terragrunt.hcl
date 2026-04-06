include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}




terraform {
  source = "../../../../modules/policy_core"
}

dependency "mg" {
  config_path = "../../root"
}


inputs = {

  policy_definitions = { 
                             ##for custom policies, we need to provide the definition in the code, for built in policies we just need to provide the guid in the module variable and it will look up the rest via data source
    enforce_default_tags = {
      name         = "enforce-default-tags"
      display_name = "Enforce default tags"
      policy_type  = "Custom"
      mode         = "All"
      management_group_id = dependency.mg.outputs.mg_ids["mg"]
      metadata     = { category = "Tags" }     
      parameters = {}

      policy_rule = {
  if = {
    anyOf = [
      { field = "tags['organization']", exists = "false" },
      { field = "tags['owner']",        exists = "false" },
      { field = "tags['creator']",      exists = "false" }
    ]
  }
  then = {
    effect = "deny"
  }
}
    }
  }
      


  policy_initiative = {
    
  name                = "Root-Guardrails"
  display_name        = "Root Guardrails Initiative"
  category            = "Governance"
  version             = "1.0.0"
  management_group_id = dependency.mg.outputs.mg_ids["mg"]

  policy_refs = [
    "allowed_locations",
    "enforce_default_tags"
  ]

  parameters_per_policy = {
  allowed_locations = jsonencode({
    listOfAllowedLocations = {
      value = ["uksouth", "ukwest"]
    }
  }) 
}
}

  
  policy_assignments = {    

    root = {
      name                  = "alz-root"
      display_name          = "Root Guardrails"
      policy_definition_ref = "root_guardrails"
      management_group_id   = dependency.mg.outputs.mg_ids["mg"]
      parameters            = null
    }

    
  }
}
