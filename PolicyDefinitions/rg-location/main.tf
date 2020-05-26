variable "allowed_locations" {
  type    = list
  default = []
}

resource "azurerm_policy_definition" "allowedlocs" {
  name                = "blk_allowed_locs"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = "OneAladdin"
  display_name        = "(BLK) list of allowed locations that can be specified when deploying resources"

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
