
variable "parameters_tag" {
  type = object({
    tagName1 = string, tagValue1 = string
    tagName2 = string, tagValue2 = string
    tagName3 = string, tagValue3 = string
    tagName4 = string, tagValue4 = string
    tagName5 = string, tagValue5 = string
    tagName6 = string, tagValue6 = string
  })
}

resource "azurerm_policy_definition" "blk_tags_policy" {
  name                = "blk_tagging_policy"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = "OneAladdin"
  display_name        = "(BLK) Add or replace a tag on resources"

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
        "defaultValue": "${var.parameters_tag["tagName1"]}"
    },
    "tagValue1": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagValue1"]}"
    },
    "tagName2": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagName2"]}"
    },
    "tagValue2": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagValue2"]}"
    },
    "tagName3": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagName3"]}"
    },
    "tagValue3": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagValue3"]}"
    },
    "tagName4": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagName4"]}"
    },
    "tagValue4": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagValue4"]}"
    },
    "tagName5": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagName5"]}"
    },
    "tagValue5": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagValue5"]}"
    },
    "tagName6": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagName6"]}"
    },
    "tagValue6": {
        "type": "String",
        "defaultValue": "${var.parameters_tag["tagValue6"]}"
    }
  }
PARAMETERS
}

