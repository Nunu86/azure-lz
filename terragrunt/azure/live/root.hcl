locals{
  #organization metadata
    organization = "nunu"
    owner = "IT"
    creator = "terraform"
    tenant_id = "b6164648-f2cf-4f8f-90e5-5958e56b5461"

    
  #subscription details
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscriptions.hcl"))
  subscriptions     = local.subscription_vars.locals.subscriptions
  remote_state_subscription = local.subscriptions["remote_state"]   #subscription where terraform state will be stored, this is just for reference in the remote state configuration in the generate block below. This subscription is not meant to be brought into terraform management.
  
  subscription_name = basename(dirname(dirname(get_terragrunt_dir())))
  default_subscription = local.subscriptions["landingzoneA"]        #default subscription to use if subscription_name is not found in subscriptions map

  subscription = lookup(local.subscriptions, local.subscription_name, local.default_subscription)
  subscription_id = local.subscription.id 

  #default_tags
  default_tags = {
    organization = local.organization
    owner        = local.owner
   creator      = local.creator
  }

}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  required_providers {
   

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.64.0"
    }
  }
}




provider "azurerm" {
  features {}
  subscription_id = "${local.subscription_id}"
  tenant_id       = "${local.tenant_id}"
  
}
EOF
}


remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    resource_group_name  = "terraform-state-backend"
    storage_account_name = "terraformstatebacken"
    container_name       = "tf-state"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    subscription_id      = local.remote_state_subscription.id       
   # use_azuread_auth     = true 
  }
}