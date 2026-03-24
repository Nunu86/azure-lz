locals {
  subscriptions = {
    landingzone = {
      id   = "bc4f7bde-466d-4d18-b8b2-735a9725ea20"
      name = "lner_sb_landingzone"
    }

    platform = {
      id   = "195bb31d-1a5e-4102-80e3-1634bdc6a736"
      name = "lner_sb_platform"
    }

    remote_state = {                                             #do not bring this subscription into terraform management, this is just for reference in the remote state configuration in root.hcl. This subscription is where the terraform state for the landingzone will be stored.
      id   = "684f6b16-5289-4d14-843b-161e82fbb6a4"
      name = "INC0243651"
    }
   
  }
}