terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
  }
}

module "transit_firenet_1" {
  source = "../.."

  cidr                   = "10.1.0.0/20"
  region                 = "West Europe"
  account                = "Azure"
  firewall_image         = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  firewall_image_version = "9.1.0"
  ha_gw                  = false
}