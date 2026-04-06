include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

locals { 

    mg_name = "nunu_mg_${basename(path_relative_to_include())}"
    mg_display_name = "${title(replace(replace(local.mg_name, "-", " "), "_", " "))}"
   
    platform_mg_name = "nunu_mg_${basename(path_relative_to_include())}"
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
      
    },

    platform_sub = {
      
    subscription_id     = "f3466ce7-9525-4306-bfe7-ee0cc1394d80"
    management_group_name = local.platform_mg_name
    
    }
    }
}