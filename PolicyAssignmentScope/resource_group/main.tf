provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "managed_identity_location" {
  type    = string
  default = "eastus"
}

variable "parameters_tags" {
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


variable "policy_prefix" {
  type    = string
  default = "/providers/Microsoft.Management/managementgroups/MG1/providers/Microsoft.Authorization/policyDefinitions"
}
variable "blk_tagging_policy_definition_id" {
  type    = string
  default = "blk_tagging_policy"
}

variable "resource_group_name" {
  type    = string
  default = "test-resources"
}

variable "subscription_id" {
  type    = string
  default = "bbda17bf-73f4-4bc5-963c-059375fabe3b"
}

resource "azurerm_policy_assignment" "blk_tagging_policy" {
  name                 = "blk_tagging_policy"
  scope                = format("/subscriptions/%s/resourceGroups/%s", var.subscription_id, var.resource_group_name)
  policy_definition_id = format("%s/%s", var.policy_prefix, var.blk_tagging_policy_definition_id)
  location             = var.managed_identity_location
  description          = "Enforce tagging upon resource creation"
  display_name         = "(BLK) Add or replace a tag on resources"
  identity { type = "SystemAssigned" }

  parameters = jsonencode(
    {
      "${var.parameters_tags["tagName1"]}" : {
        "value" : var.parameters_tags["tagValue1"]
      },
      "${var.parameters_tags["tagName2"]}" : {
        "value" : var.parameters_tags["tagValue2"]
      },
      "${var.parameters_tags["tagName3"]}" : {
        "value" : var.parameters_tags["tagValue3"]
      },
      "${var.parameters_tags["tagName4"]}" : {
        "value" : var.parameters_tags["tagValue4"]
      },
      "${var.parameters_tags["tagName5"]}" : {
        "value" : var.parameters_tags["tagValue5"]
      },
      "${var.parameters_tags["tagName6"]}" : {
        "value" : var.parameters_tags["tagValue6"]
      }
  })
}
