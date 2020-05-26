provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "parameters_tag" {
  type = object({
    tagName1 = string, tagValue1 = string
    tagName2 = string, tagValue2 = string
    tagName3 = string, tagValue3 = string
    tagName4 = string, tagValue4 = string
    tagName5 = string, tagValue5 = string
    tagName6 = string, tagValue6 = string
  })
  default = {
    tagName1 = "black_resource_owner", tagValue1 = "black_resource_owner_value"
    tagName2 = "black_application_id", tagValue2 = "black_application_id_value"
    tagName3 = "black_business_unit", tagValue3 = "black_business_unit_value"
    tagName4 = "black_data_class", tagValue4 = "black_data_class_value"
    tagName5 = "black_client_name", tagValue5 = "black_client_name_value"
    tagName6 = "black_app_version", tagValue6 = "black_app_version_value"
  }
}

variable "allowed_locations" {
  type    = list
  default = ["eastus", "eastus2", "westus", "westus2"]
}

module "resource_group_locations" {
  source = "./rg-location/"
}

module "restrict_public_ip" {
  source = "./restrict-public-ip/"
}

module "resource_tags" {
  source         = "./resource-tagging/"
  parameters_tag = var.parameters_tag
}

module "deny_well_known_ports" {
  source = "./deny-well-known-ports/"
}

module "deny_any_any_inbound" {
  source = "./deny-any-any-inbound/"
}



