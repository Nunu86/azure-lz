locals {
  # organisation metadata
  organisation = "lner"
  owner        = "IT"
  creator      = "terraform"
  tenant_id    = "72f988bf-86f1-41af-91ab-2d7cd011db47"

  # environment
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  env              = local.environment_vars.locals.environment

  # subscriptions
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscriptions.hcl"))
  subscriptions     = local.subscription_vars.locals.subscriptions 
  subscription_name = basename(dirname(dirname(path_relative_to_include())))
  subscription_id = local.subscriptions[local.subscription_name]

  # repo metadata
  repo            = "${basename(get_repo_root())}"

  #global tags
  global_tags = {
    prefix      = "lner"
    environment = local.env
    location    = "eu-west-2"
  }

}

# Terraform config 
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.62.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "${local.subscription_id}"
  tenant_id       = "${local.tenant_id}"

  default_tags {
    tags = {
      environment  = "${local.env}"
      organisation = "${local.organisation}"
      owner        = "${local.owner}"
      creator      = "${local.creator}"
      repo         = "${local.repo}"
    }
  }
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
    resource_group_name  = "rg-terraform-state"            # RG containing storage account
    storage_account_name = "terraformstateaccount"         # Storage account name
    container_name       = "tfstate"                        # Blob container name
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    subscription_id      = var.subscription_id             # Optional: subscription containing storage account
  }
}











