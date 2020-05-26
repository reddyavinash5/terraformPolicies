provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "scope" {
  type    = string
  default = "/providers/Microsoft.Management/managementGroups/OneAladdin"
}

resource "azurerm_policy_definition" "denypublicip" {
  name                = "Deny Resource Type Public IP"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = "OneAladdin"
  display_name        = "Deny resource type public ip"

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA

  policy_rule = <<POLICY_RULE
{
      "if": {
        "anyOf": [
          {
            "source": "action",
            "like": "Microsoft.Network/publicIPAddresses/*"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
}
POLICY_RULE

}

resource "azurerm_policy_assignment" "denypubip" {
  name                 = "denypubIp"
  scope                = var.scope
  policy_definition_id = azurerm_policy_definition.denypublicip.id
  description          = "Deny resource type public ip"
  display_name         = "Deny resource type public ip"
}
