include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  mg_vars = read_terragrunt_config(find_in_parent_folders("management_groups.hcl"))
  mg      = local.mg_vars.locals.management_groups["platform"]
}

terraform {
  source = "../../../modules/caf_management_group"
}

inputs = {
  mg_config = {
    name               = local.mg.name
    display_name       = local.mg.display_name
    parent_id          = local.mg.parent
    subscription_ids   = [
      local.subscriptions["identity"],
      local.subscriptions["management"],
      local.subscriptions["networking"]
    ]
    policy_assignments = {}
  }
}