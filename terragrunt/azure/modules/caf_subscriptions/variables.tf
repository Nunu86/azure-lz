variable "mg_config" {
  description = "Management Group configuration" #change for subscription configuration
  type = map(object({
    name       = string
    display_name = string    
    subscription_id = optional(list(string))
    policy_assignments   = optional(map(any), {})
    role_assignments = optional(map(any), {})
    diagnostic_settings = optional(map(any), {})
  }))
}