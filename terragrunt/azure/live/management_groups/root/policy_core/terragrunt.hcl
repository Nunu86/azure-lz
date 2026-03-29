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
    enforce_default_tags = {
      name         = "enforce-default-tags"
      display_name = "Enforce default tags"
      policy_type  = "Custom"
      mode         = "All"
      management_group_id = dependency.mg.outputs.mg_ids["mg"]
      metadata     = { category = "Tags" }      
      parameters   = {
        tags = {
          type = "Object"
        }
      }
    }
  }

  policy_assignments = {

    default_tags = {
      name                  = "default-tags"
      display_name          = "Default Tags"
      policy_definition_ref = "enforce_default_tags"     
      management_group_id = dependency.mg.outputs.mg_ids["mg"]
      parameters = {
        tags = {
          value =  include.root.locals.default_tags
          
        }
      }
    }
  }
}
