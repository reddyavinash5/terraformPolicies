provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "policy_prefix" {
  type    = string
  default = "/providers/Microsoft.Management/managementgroups/OneAladdin/providers/Microsoft.Authorization/policyDefinitions"
}

variable "blk_allowed_locs_definition_id" {
  type    = string
  default = "blk_allowed_locs"
}

variable "subscription_id" {
  type    = string
  default = "bbda17bf-73f4-4bc5-963c-059375fabe3b"
}

resource "azurerm_policy_assignment" "blk_allowed_locations" {
  name                 = "blk_allowed_locs"
  scope                = format("/subscriptions/%s", var.subscription_id)
  policy_definition_id = format("%s/%s", var.policy_prefix, var.blk_allowed_locs_definition_id)
  description          = "Policy to enforce list of allowed locations"
  display_name         = "Policy to enforce list of allowed locations at subscription level"
}
