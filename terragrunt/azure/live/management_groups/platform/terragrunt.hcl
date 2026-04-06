include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals { 

    mg_name = "nunu_mg_${basename(path_relative_to_include())}"
    mg_display_name = "${title(replace(replace(local.mg_name, "-", " "), "_", " "))}"

} 


terraform {
  source = "../../../modules/management_group"
}

dependency "mg" {
  config_path = "../root"
}

inputs = {
  mg_config = {
    platform ={
      name         = local.mg_name
      display_name = local.mg_display_name      
      parent_mg_id = dependency.mg.outputs.mg_ids["mg"]
     # default_tags = include.root.locals.default_tags
  }}
}

