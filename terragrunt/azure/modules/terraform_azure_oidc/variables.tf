variable "azure_oidc_config" {
  type = map(object({
    issuer_url     = string
    subject        = string
    audiences      = list(string)
    role_assignments = list(object({
      role_definition_name = string
      scope              = string
    }))
  }))

  default = {
    github = {
      issuer_url = "https://token.actions.githubusercontent.com"
      subject    = "repo:<org>/<repo>:ref:refs/heads/main"
      audiences  = ["api://AzureADTokenExchange"]

      role_assignments = []
    }
  }
}