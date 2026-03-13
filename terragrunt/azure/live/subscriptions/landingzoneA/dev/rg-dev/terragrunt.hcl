include{
    path = find_in_parent_folders("root.hcl")
}
/*
locals {
  # Get subscription name dynamically from folder structure, 
  # assuming `landingzoneA` is first folder under `subscriptions/`
  subscription_name = split("/", path_relative_to_include())[4] #this needs to resolve to landingzoneA

  # Load centralized subscription data
  subscription_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  
  subscription_id   = local.subscription_vars.locals.subscriptions[local.subscription_name].id
  #tenant_id         = "your-tenant-id-here"
}
*/
terraform {
  source = "../../../../../modules/caf_management_group"  # adjust relative path to your modules folder
}

inputs = {
 
 #subscription_id = local.subscription_id
  
  
 # tenant_id       = local.tenant_id

  # Add other inputs your module needs here
}