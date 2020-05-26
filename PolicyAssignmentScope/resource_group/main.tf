provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "managed_identity_location" {
  type    = string
  default = "eastus"
}

variable "policy_prefix" {
  type    = string
  default = "/providers/Microsoft.Management/managementgroups/OneAladdin/providers/Microsoft.Authorization/policyDefinitions"
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
}
