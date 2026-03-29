
variable "sub_config" {
  type = map(object({
    #name                = string
    subscription_id     = string
  #  display_name        = string
   # billing_scope_id    = string
   # workload            = string
    management_group_name = string
    policy_assignments  = optional(map(any), {})
    role_assignments    = optional(map(any), {})
    diagnostic_settings = optional(map(any), {})
    tags                = optional(map(string), {})
  }))
}

