/*variable "policy_definitions" {
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

variable "built_in_policies" {
  description = "Map of built-in policies (key = ref name, value = display name)"
  type        = map(string)
  default     = {}
}
*/
variable "policy_definitions" {
  type = map(object({
    name                 = string
    display_name         = string
    mode                 = string
    management_group_id  = string
    metadata             = map(any)
    parameters           = optional(map(any))
    
   

    # Choose ONE of these
    policy_rule_path     = optional(string)
    policy_rule          = optional(any)
  }))
  default = {}
}

variable "policy_initiative" {
  type = object({
    name                  = string
    description           = optional(string)
    display_name          = string
    management_group_id   = string
    category              = string    
    version               = string
    policy_refs           = list(string)
    parameters_per_policy = optional(map(string))   # 🔥 now string, not any
  })
}

variable "policy_assignments" {
  type = map(object({
    name                  = string
    display_name          = string
    policy_definition_ref = string
    management_group_id   = string
    parameters            = optional(map(any), {})
    identity_required     = optional(bool, false)
  }))
}

variable "policy_exemptions" {
  type = map(object({
    name                 = string
    resource_id          = string
    #scope                = string
    policy_assignment_id = string
    exemption_category   = string
    display_name         = string
    description          = string
  }))
  default = {}
}






