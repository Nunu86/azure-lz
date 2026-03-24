include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
locals {
    subscription_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
    subscriptions     = local.subscription_vars.locals.subscriptions
    mg_key  = "mg"
   
}
    


terraform {
  source = "../../modules/subscription"
}


inputs = {
  sb_config = {
    sb ={
      name            = local.subscriptions.landingzone.name     
      subscription_id = local.subscriptions.landingzone.id           
      management_group_id = dependency.management_groups.outputs.mg_ids[local.mg_key]
      default_tags = include.root.locals.default_tags
  }}
}


dependency "management_groups" {
  config_path = "../../management_groups/landingzone"
}

