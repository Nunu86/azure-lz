variable "policy_definitions" {
  type = map(object({
    name         = string
    display_name = string
    policy_type  = string
    mode         = string
    metadata     = map(any)    
    parameters   = map(any)
    management_group_id   = string
  }))
}



variable "policy_assignments" {
  type = map(object({
    name                  = string
    display_name          = string    
    policy_definition_ref = string
    parameters            = map(any)
    management_group_id   = string
  }))
}

