include{
    path = find_in_parent_folders("root.hcl")
}

locals {
  extra_tags = {}
}




terraform {
  source = "../../../../../modules/caf_management_group"  # adjust relative path to your modules folder
}

inputs = {
 
 #subscription_id = local.subscription_id
  
  
 # tenant_id       = local.tenant_id

  # Add other inputs your module needs here
}