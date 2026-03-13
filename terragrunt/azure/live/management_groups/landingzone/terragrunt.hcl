include{
    path = find_in_parent_folders("root.hcl")
}
locals {
   # default_root_mg_id = "00000000-0000-0000-0000-000000000000"
   # root_mg_id = "/providers/Microsoft.Management/managementGroups/${local.default_root_mg_id}"

    mg_name = basename(path_relative_to_include())
    mg_display_name = "LNER ${title(
  replace(
    replace(local.mg_name, "-", " "),
    "_", " "
  )
)} MG"
}


terraform {
  source = "../../../modules/caf_management_group"
}

inputs = {
  mg_config = {
    mg1 = {
      name         = local.mg_name
      display_name = local.mg_display_name      
      parent_mg_id = ""
    }
    
    # Add more MGs here if needed
  }
}


