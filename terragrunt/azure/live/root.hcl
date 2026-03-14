locals{
    organization = "nunu"
    owner = "nunu"
    creator = "nunu"
    tenant_id = "b6164648-f2cf-4f8f-90e5-5958e56b5461"

    default_tags = {
    organization = local.organization
    owner        = local.owner
    creator      = local.creator
  }

  subscription_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  subscriptions     = local.subscription_vars.locals.subscriptions

  default_subscription = local.subscriptions["default"]

 # subscription_folder_name = try(split("/", path_relative_to_include())[1], "")
  subscription_folder_name = try(
    basename(dirname(dirname(get_terragrunt_dir()))),
    "default"
  )

  subscription = lookup(local.subscriptions, local.subscription_folder_name, local.default_subscription
  )

  subscription_id = local.subscription.id 

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
    subscription_id       = "52ba7fb7-08a0-4331-a775-d69765fc76ec"
    use_azuread_auth     = true 
  }
}