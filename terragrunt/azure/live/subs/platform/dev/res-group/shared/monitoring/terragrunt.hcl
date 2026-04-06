include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../../../modules/monitoring"
}

inputs = {
  workspace_name = "platform-law"
  resource_group = "rg-platform-logging"
  location       = "uksouth"
}
