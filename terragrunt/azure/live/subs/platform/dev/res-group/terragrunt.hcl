include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

locals{
  default_tags = include.root.locals.default_tags
}

terraform {
  source = "../../../../../modules/resource_group"
}



inputs = {
    rg_config = {
        rg_monitoring = {
            name     = "monitoring_rg"    #use locals later for naming convention
            location = "uksouth"
            tags     = local.default_tags
            subscription_id     = "f3466ce7-9525-4306-bfe7-ee0cc1394d80"  #use locals later
            
      
    }
    }
  
}



