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

variable "scope" {
  type    = string
  default = "/subscriptions/bbda17bf-73f4-4bc5-963c-059375fabe3b/resourceGroups/test-resources"
}

resource "azurerm_policy_definition" "policy" {
  name                = "customTagging"
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = "OneAladdin"
  display_name        = "Resource Tagging Policy"

  metadata = <<METADATA
    {
    "category": "Tags"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
            "allOf": [
                {
                   "field": "[concat('tags[', parameters('tagName1'), ']')]",
                    "exists": "false"
                },
                {
                   "field": "[concat('tags[', parameters('tagName2'), ']')]",
                    "exists": "false"
                },
                {
                   "field": "[concat('tags[', parameters('tagName3'), ']')]",
                    "exists": "false"
                },
                {
                   "field": "[concat('tags[', parameters('tagName4'), ']')]",
                    "exists": "false"
                },
                {
                   "field": "[concat('tags[', parameters('tagName5'), ']')]",
                    "exists": "false"
                },
                {
                   "field": "[concat('tags[', parameters('tagName6'), ']')]",
                    "exists": "false"
                }
            ]
        },
       "then": {
            "effect": "modify",
            "details": {
               "roleDefinitionIds": [
                  "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
               ],
               "operations": [
                  {
                     "operation": "addOrReplace",
                     "field": "[concat('tags[', parameters('tagName1'), ']')]",
                     "value": "[parameters('tagValue1')]"
                  },
                  {
                     "operation": "addOrReplace",
                     "field": "[concat('tags[', parameters('tagName2'), ']')]",
                     "value": "[parameters('tagValue2')]"
                  },
                  {
                     "operation": "addOrReplace",
                     "field": "[concat('tags[', parameters('tagName3'), ']')]",
                     "value": "[parameters('tagValue3')]"
                  },
                  {
                     "operation": "addOrReplace",
                     "field": "[concat('tags[', parameters('tagName4'), ']')]",
                     "value": "[parameters('tagValue4')]"
                  },
                  {
                     "operation": "addOrReplace",
                     "field": "[concat('tags[', parameters('tagName5'), ']')]",
                     "value": "[parameters('tagValue5')]"
                  },
                  {
                     "operation": "addOrReplace",
                     "field": "[concat('tags[', parameters('tagName6'), ']')]",
                     "value": "[parameters('tagValue6')]"
                  }
               ]
            }
         }
  }
POLICY_RULE

  parameters = <<PARAMETERS
    {
    "tagName1": {
        "type": "String",
        "defaultValue": "${var.parameters_names["tagName1"]}"
    },
    "tagValue1": {
        "type": "String",
        "defaultValue": "${var.parameters_values["tagValue1"]}"
    },
    "tagName2": {
        "type": "String",
        "defaultValue": "${var.parameters_names["tagName2"]}"
    },
    "tagValue2": {
        "type": "String",
        "defaultValue": "${var.parameters_values["tagValue2"]}"
    },
    "tagName3": {
        "type": "String",
        "defaultValue": "${var.parameters_names["tagName3"]}"
    },
    "tagValue3": {
        "type": "String",
        "defaultValue": "${var.parameters_values["tagValue3"]}"
    },
    "tagName4": {
        "type": "String",
        "defaultValue": "${var.parameters_names["tagName4"]}"
    },
    "tagValue4": {
        "type": "String",
        "defaultValue": "${var.parameters_values["tagValue4"]}"
    },
    "tagName5": {
        "type": "String",
        "defaultValue": "${var.parameters_names["tagName5"]}"
    },
    "tagValue5": {
        "type": "String",
        "defaultValue": "${var.parameters_values["tagValue5"]}"
    },
    "tagName6": {
        "type": "String",
        "defaultValue": "${var.parameters_names["tagName6"]}"
    },
    "tagValue6": {
        "type": "String",
        "defaultValue": "${var.parameters_values["tagValue6"]}"
    }
  }
PARAMETERS
}

resource "azurerm_policy_assignment" "tagging_assignment" {
  name                 = "tagging_assignment"
  scope                = "/providers/Microsoft.Management/managementGroups/OneAladdin"
  policy_definition_id = azurerm_policy_definition.policy.id
  description          = "Policy assignment for custom tagging"
  display_name         = "Policy assignment for custom tagging"
}

