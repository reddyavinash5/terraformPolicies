
resource "azurerm_policy_definition" "blk_deny_Well_Known_Ports" {
  name                = "blk_deny_well_known_ports"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "(BLK) Deny well known ports"
  management_group_id = "OneAladdin"

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA

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

  parameters = <<PARAMETERS
     {
      "name": {
        "type": "String",
        "metadata": {
          "displayName": "DenyWellKnownPorts",
          "description": "This policy appends a new rule to NSG to deny well known ports(0-1024)"
        },
        "defaultValue": "DenyWellKnownPorts"
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
          "0-1024"
        ]
      },
      "destinationPortRange": {
        "type": "Array",
        "metadata": {
          "displayName": "destinationPortRange",
          "description": "The destination port or range. Integer or range between 0 and 65535. Asterisk '*' can also be used to match all ports."
        },
        "defaultValue": [
          "0-1024"
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
        "defaultValue": 4085
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
}

