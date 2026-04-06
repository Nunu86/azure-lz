variable "workspaces_config" {
  type = map(object({
    
    workspace_name      = string
    workspace_id        = string
    resource_group_name = string
  }))
}

variable "log_analytics_role_config" {
  type    = object({
    principal_id        = string
  })
}

  