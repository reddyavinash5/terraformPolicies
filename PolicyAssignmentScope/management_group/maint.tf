provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "policy_prefix" {
  type    = string
  default = "/providers/Microsoft.Management/managementgroups/OneAladdin/providers/Microsoft.Authorization/policyDefinitions"
}

variable "blk_deny_well_known_policy_definition_id" {
  type    = string
  default = "blk_deny_well_known_ports"
}
variable "blk_restrict_public_ip_definition_id" {
  type    = string
  default = "blk_restrict_public_ip"
}
variable "blk_deny_any_any_inbound_definition_id" {
  type    = string
  default = "blk_deny_any_any_inbound"
}

variable "scope" {
  type    = string
  default = "/providers/Microsoft.Management/managementGroups/OneAladdin"
}

resource "azurerm_policy_assignment" "deny_well_known_ports" {
  name                 = "deny_well_known_ports"
  scope                = var.scope
  policy_definition_id = format("%s/%s", var.policy_prefix, var.blk_deny_well_known_policy_definition_id) //azurerm_policy_definition.DenyWellKnownPorts.id
  description          = "NSG rule to deny access to well known ports (0-1024)"
  display_name         = "(Blk) Deny Access to Well Known Ports (0-1024)"
}

resource "azurerm_policy_assignment" "deny_any_any_inbound" {
  name                 = "deny_any_any_inbound"
  scope                = var.scope
  policy_definition_id = format("%s/%s", var.policy_prefix, var.blk_deny_any_any_inbound_definition_id) //azurerm_policy_definition.DenyWellKnownPorts.id
  description          = "NSG rule to deny any/any inbound traffic"
  display_name         = "(Blk) Deny Access to any/any inbound traffic"
}

resource "azurerm_policy_assignment" "restrict_public_ip" {
  name                 = "restrict_public_ip"
  scope                = var.scope
  policy_definition_id = format("%s/%s", var.policy_prefix, var.blk_restrict_public_ip_definition_id) //azurerm_policy_definition.DenyWellKnownPorts.id
  description          = "This policy denies the creation of resource type public ip"
  display_name         = "(Blk) Deny Access to create resource type public ip"
}
