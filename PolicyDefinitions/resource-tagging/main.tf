provider "azurerm" {
  version = "=2.0.0"
  features {}
}
variable "parameters_tags" {
  type = object({
    tagName1 = string
    tagName2 = string
    tagName3 = string
    tagName4 = string
    tagName5 = string
    tagName6 = string
  })
  default = {
    tagName1 = ""
    tagName2 = ""
    tagName3 = ""
    tagName4 = ""
    tagName5 = ""
    tagName6 = ""
  }
}

resource "azurerm_policy_definition" "blk_tags_policy" {
  name                = "blk_tagging_policy"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = "MG1"
  display_name        = "(BLK) Add or replace a tag on resources"

  metadata = <<METADATA
    {
    "category": "Tags"
    }

METADATA


  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "[concat('tags[', '${var.parameters_tags["tagName1"]}', ']')]",
            "exists" : "false"
          },
          {
            "field" : "[concat('tags[', '${var.parameters_tags["tagName2"]}', ']')]",
            "exists" : "false"
          },
          {
            "field" : "[concat('tags[', '${var.parameters_tags["tagName3"]}', ']')]",
            "exists" : "false"
          },
          {
            "field" : "[concat('tags[', '${var.parameters_tags["tagName4"]}', ']')]",
            "exists" : "false"
          },
          {
            "field" : "[concat('tags[', '${var.parameters_tags["tagName5"]}', ']')]",
            "exists" : "false"
          },
          {
            "field" : "[concat('tags[', '${var.parameters_tags["tagName6"]}', ']')]",
            "exists" : "false"
          }
        ]
      },
      "then" : {
        "effect" : "modify",
        "details" : {
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "operations" : [
            {
              "operation" : "addOrReplace",
              "field" : "[concat('tags[', '${var.parameters_tags["tagName1"]}', ']')]",
              "value" : "[parameters('${var.parameters_tags["tagName1"]}')]"
            },
            {
              "operation" : "addOrReplace",
              "field" : "[concat('tags[', '${var.parameters_tags["tagName2"]}', ']')]",
              "value" : "[parameters('${var.parameters_tags["tagName2"]}')]"
            },
            {
              "operation" : "addOrReplace",
              "field" : "[concat('tags[', '${var.parameters_tags["tagName3"]}', ']')]",
              "value" : "[parameters('${var.parameters_tags["tagName3"]}')]"
            },
            {
              "operation" : "addOrReplace",
              "field" : "[concat('tags[', '${var.parameters_tags["tagName4"]}', ']')]",
              "value" : "[parameters('${var.parameters_tags["tagName4"]}')]"
            },
            {
              "operation" : "addOrReplace",
              "field" : "[concat('tags[', '${var.parameters_tags["tagName5"]}', ']')]",
              "value" : "[parameters('${var.parameters_tags["tagName5"]}')]"
            },
            {
              "operation" : "addOrReplace",
              "field" : "[concat('tags[', '${var.parameters_tags["tagName6"]}', ']')]",
              "value" : "[parameters('${var.parameters_tags["tagName6"]}')]"
            }
          ]
        }
      }
  })

  parameters = jsonencode(
    {
      "${var.parameters_tags["tagName1"]}" : {
        "type" : "String"
        "defaultValue" : ""
      },
      "${var.parameters_tags["tagName2"]}" : {
        "type" : "String"
        "defaultValue" : ""
      },
      "${var.parameters_tags["tagName3"]}" : {
        "type" : "String"
        "defaultValue" : ""
      },
      "${var.parameters_tags["tagName4"]}" : {
        "type" : "String"
        "defaultValue" : ""
      },
      "${var.parameters_tags["tagName5"]}" : {
        "type" : "String"
        "defaultValue" : ""
      },
      "${var.parameters_tags["tagName6"]}" : {
        "type" : "String"
        "defaultValue" : ""
      }
  })
}

