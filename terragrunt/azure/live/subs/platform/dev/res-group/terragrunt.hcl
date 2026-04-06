include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../../modules/resource_group"
}



inputs = {
    rg_config = {
        rg_monitoring = {
            name     = "monitoring_rg"    #use locals later for naming convention
            location = "uksouth"
           # tags     = var.rg_config[each.key].tags
            subscription_id     = "74f716ee-8c27-4536-9049-18595b2b91ee"  #use locals later
            
      
    }
    }
  
}



