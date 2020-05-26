provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "scope" {
  type    = string
  default = "/providers/Microsoft.Management/managementGroups/OneAladdin"
}

resource "azurerm_policy_definition" "InboundDeny" {
  name                = "Deny Any/Any Inbound"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = "OneAladdin"
  display_name        = "Deny Any/Any Inbound traffic"

  metadata   = <<METADATA
    {
    "category": "General"
    }

METADATA
  parameters = <<PARAMETERS
     {
      "name": {
        "type": "String",
        "metadata": {
          "displayName": "Deny Any/Any Inbound traffic",
          "description": "Deny Any/Any Inbound traffic"
        },
        "defaultValue": "DenyAny/AnyInbound"
      },
      "protocol": {
        "type": "String",
        "metadata": {
          "displayName": "protocol",
          "description": "Network protocol this rule applies to. - Tcp, Udp, Icmp, Esp, *, Ah"
        },
        "defaultValue": "*"
      },
      "sourcePortRange": {
        "type": "Array",
        "metadata": {
          "displayName": "sourcePortRange",
          "description": "The source port or range. Integer or range between 0 and 65535. Asterisk '*' can also be used to match all ports."
        },
        "defaultValue": [
          "*"
        ]
      },
      "destinationPortRange": {
        "type": "Array",
        "metadata": {
          "displayName": "destinationPortRange",
          "description": "The destination port or range. Integer or range between 0 and 65535. Asterisk '*' can also be used to match all ports."
        },
        "defaultValue": [
          "*"
        ]
      },
      "sourceAddressPrefix": {
        "type": "Array",
        "metadata": {
          "displayName": "sourceAddressPrefix",
          "description": "The CIDR or source IP range. Asterisk '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used. If this is an ingress rule, specifies where network traffic originates from."
        },
        "defaultValue": [
          "*"
        ]
      },
      "destinationAddressPrefix": {
        "type": "Array",
        "metadata": {
          "displayName": "destinationAddressPrefix",
          "description": "The destination address prefix. CIDR or destination IP range. Asterisk '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used."
        },
        "defaultValue": [
          "*"
        ]
      },
      "access": {
        "type": "String",
        "metadata": {
          "displayName": "access",
          "description": "The network traffic is allowed or denied. - Allow or Deny"
        },
        "defaultValue": "deny"
      },
      "priority": {
        "type": "Integer",
        "metadata": {
          "displayName": "priority",
          "description": "The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule."
        },
        "defaultValue": 4096
      },
      "direction": {
        "type": "String",
        "metadata": {
          "displayName": "direction",
          "description": "The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. - Inbound or Outbound"
        },
        "defaultValue": "Inbound"
      }
    }
PARAMETERS

  policy_rule = <<POLICY_RULE
{    
      "if": {
        "field": "type",
        "equals": "Microsoft.Network/networkSecurityGroups"
      },
      "then": {
        "effect": "append",
        "details": [
          {
            "field": "Microsoft.Network/networkSecurityGroups/securityRules[*]",
            "value": {
              "name": "[parameters('name')]",
              "properties": {
                "protocol": "[parameters('protocol')]",
                "sourcePortRange": "[if(equals(length(parameters('sourcePortRange')), 1), parameters('sourcePortRange')[0], json('null'))]",
                "sourcePortRanges": "[if(greater(length(parameters('sourcePortRange')), 1), parameters('sourcePortRange'), json('null'))]",
                "destinationPortRange": "[if(equals(length(parameters('destinationPortRange')), 1), parameters('destinationPortRange')[0], json('null'))]",
                "destinationPortRanges": "[if(greater(length(parameters('destinationPortRange')), 1), parameters('destinationPortRange'), json('null'))]",
                "sourceAddressPrefix": "[if(equals(length(parameters('sourceAddressPrefix')), 1), parameters('sourceAddressPrefix')[0], json('null'))]",
                "sourceAddressPrefixes": "[if(greater(length(parameters('sourceAddressPrefix')), 1), parameters('sourceAddressPrefix'), json('null'))]",
                "destinationAddressPrefix": "[if(equals(length(parameters('destinationAddressPrefix')), 1), parameters('destinationAddressPrefix')[0], json('null'))]",
                "destinationAddressPrefixes": "[if(greater(length(parameters('destinationAddressPrefix')), 1), parameters('destinationAddressPrefix'), json('null'))]",
                "access": "[parameters('access')]",
                "priority": "[parameters('priority')]",
                "direction": "[parameters('direction')]"
              }
            }
          }
        ]
      }
    }
  POLICY_RULE
}

resource "azurerm_policy_assignment" "inbounddeny" {
  name                 = "inbounddeny"
  scope                = var.scope
  policy_definition_id = azurerm_policy_definition.InboundDeny.id
  description          = "This policy appends a rule to NSG to deny any/any inbound traffic"
  display_name         = "Deny Any/Any inbound traffic"
}
