provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "scope" {
  type    = string
  default = "/subscriptions/bbda17bf-73f4-4bc5-963c-059375fabe3b"
}

variable "allowed_locations" {
  type    = list
  default = ["eastus", "eastus2", "westus", "westus2"]
}


resource "azurerm_policy_definition" "allowedlocs" {
  name                = "Restrict Allowed Locs"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = "OneAladdin"
  display_name        = "The list of locations that can be specified when deploying resources"

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA

  policy_rule = <<POLICY_RULE
{
      "if": {
        "allOf": [
          {
            "field": "location",
            "notIn": "[parameters('listOfAllowedLocations')]"
          },
          {
            "field": "location",
            "notEquals": "global"
          },
          {
            "field": "type",
            "notEquals": "Microsoft.AzureActiveDirectory/b2cDirectories"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
    POLICY_RULE


  parameters = <<PARAMETERS
{
      "listOfAllowedLocations": {
        "type": "Array",
        "metadata": {
          "description": "The list of locations that can be specified when deploying resources.",
          "strongType": "location",
          "displayName": "Allowed locations"
        },
        "defaultValue": []
      }
    }
    PARAMETERS
}

resource "azurerm_policy_assignment" "allowed_locations" {
  name                 = "allowedlocs"
  scope                = var.scope
  policy_definition_id = azurerm_policy_definition.allowedlocs.id
  description          = "The list of locations that can be specified when deploying resources"
  display_name         = "The list of locations that can be specified when deploying resources"

  parameters = <<PARAMETERS
  {
    "listOfAllowedLocations":
    {
      "value" :  ["var.allowed_locations"]
    }
  }
  PARAMETERS
}
