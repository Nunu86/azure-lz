include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
locals{
  default_tags = include.root.locals.default_tags
}
terraform {
  source = "../../../../../../../modules/monitoring"
}

#dependency "policy_platform" {
#  config_path = "../../../../../../management_groups/platform/policy_platform"
#}

inputs = {
  workspaces_config = {
    central = {
      workspace_name      = "log-central"
      resource_group_name = "monitoring_rg"
      location            = "uksouth"
      retention_in_days   = 30
      tags                = local.default_tags
    }
  }

  
}