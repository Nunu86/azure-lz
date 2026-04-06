include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../modules/subscription"
}



inputs = {
    sub_config = {
        subs_lz = {
    subscription_id     = "74f716ee-8c27-4536-9049-18595b2b91ee"
    management_group_name = "nunu_mg_root"
     # name                = "landingzoneA"
      #display_name        = "Landing Zone A"
      #billing_scope_id    = "/billingAccounts/000000-000000-000000/enrollmentAccounts/000000-000000-000000/billingProfiles/000000-000000-000000/billingSubscriptions/000000-000000-000000"
      #workload            = "Production"
      
    }
    }
  
}