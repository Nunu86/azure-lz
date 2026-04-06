variable "workspaces_config" {
  type = map(object({
    workspace_name      = string
    location            = string
    resource_group_name = string
    retention_in_days   = number
    tags                = optional(map(string), {})
  }))
}

