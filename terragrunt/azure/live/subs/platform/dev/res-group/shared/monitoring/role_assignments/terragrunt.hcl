include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../../../../../modules/monitoring/role_assignments"
}

dependency "policy_platform" {
  config_path = "../../../../../../../management_groups/platform/policy_platform"
}

dependency "monitoring" {
  config_path = "../../monitoring"
}

inputs = {  

log_analytics_role_config = {
   principal_id        = dependency.policy_platform.outputs.policy_assignment_principal_ids["platform"]

} 

workspaces_config = {
  central = {
   
    workspace_name      = dependency.monitoring.outputs.workspace_name["central"]
    workspace_id        = dependency.monitoring.outputs.workspace_id["central"]
    resource_group_name = "monitoring_rg"
  }
}


}

  
  

