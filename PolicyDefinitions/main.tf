provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "parameters_tags" {
  type = object({
    tagName1 = string
    tagName2 = string
    tagName3 = string
    tagName4 = string
    tagName5 = string
    tagName6 = string
  })
  default = {
    tagName1 = ""
    tagName2 = ""
    tagName3 = ""
    tagName4 = ""
    tagName5 = ""
    tagName6 = ""
  }
}

module "resource_group_locations" {
  source = "./rg-location/"
}

module "restrict_public_ip" {
  source = "./restrict-public-ip/"
}

module "resource_tags" {
  source          = "./resource-tagging/"
  parameters_tags = var.parameters_tags
}

module "deny_well_known_ports" {
  source = "./deny-well-known-ports/"
}

module "deny_any_any_inbound" {
  source = "./deny-any-any-inbound/"
}



