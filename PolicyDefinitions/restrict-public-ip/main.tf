
resource "azurerm_policy_definition" "denypublicip" {
  name                = "blk_restrict_public_ip"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = "OneAladdin"
  display_name        = "(BLK) Deny resource type public ip"

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
