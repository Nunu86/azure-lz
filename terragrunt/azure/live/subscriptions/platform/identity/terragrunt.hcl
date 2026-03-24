include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  subscription_id = local.subscription_id
  environment     = local.env
}
