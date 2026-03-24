include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/caf_subscription"
}

locals {
  workload_map = {
    dev   = "DevTest"
    stage = "NonProduction"
    prod  = "Production"
  }
}

inputs = {
  resource_group_name = dependency.rg_networking.outputs.name
  sub_config = {
    subscription_name   = "landingzoneA-dev"
    billing_scope_id    = var.billing_scope_id
    workload            = "DevTest"
    management_group_id = local.management_groups["landingzones"]
    policy_assignments  = {}
  }
}

dependencies #dependent on subscriptions add this
