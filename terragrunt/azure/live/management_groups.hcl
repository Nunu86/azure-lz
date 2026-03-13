/*
locals{
    management_groups = {
        root = {
            name      = dependency.mg_root.outputs.root_mg["name"]
            id        = dependency.mg_root.outputs.root_mg["id"]
            parent_id = null
        }
        landingzone = {
            name = "landingzone"           
            parent_id = dependency.mg_root.outputs.root_mg["id"]
        }
    }
}
*/

locals {
  management_groups = {
    root = {
      name      = root_name       # ✅ just the input name
      id        = root_id
      parent_id = null
    }
    landingzone = {
      name      = "landingzone"
      id        = landingzone_id
      parent_id = root_id
    }
  }
}