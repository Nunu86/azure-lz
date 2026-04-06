variable "rg_config" {
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})   # make tags optional and default to empty map
  }))
}