variable "mg_config" {
  description = "Management Group configuration"
  type = map(object({
    name       = string
    display_name = string     
    parent_mg_id = string  
    #subscription_id = optional(list(string))
    policy_assignments   = optional(map(any), {})
    role_assignments = optional(map(any), {})
    diagnostic_settings = optional(map(any), {})
    default_tags = optional(map(string), {})
    #tags  = map(string)
    
  }))
}
