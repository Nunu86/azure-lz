include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals { 

    mg_name = "lner_mg_${basename(path_relative_to_include())}"
    mg_display_name = "${title(replace(replace(local.mg_name, "-", " "), "_", " "))}"

} 


terraform {
  source = "../../../modules/caf_management_group"
}

inputs = {
  mg_config = {
    mg ={
      name         = local.mg_name
      display_name = local.mg_display_name      
      parent_mg_id = ""
      default_tags = include.root.locals.default_tags
  }}
}