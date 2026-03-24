include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/resource_group"
}


inputs = {
  rg_config = {
    name     = "rg-${local.env}-networking"
    location = "uksouth"
    tags     = {
      environment = local.env
      repo        = local.repo
      owner       = local.owner
    }
  }
}
