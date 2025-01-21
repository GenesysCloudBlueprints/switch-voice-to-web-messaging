/*
  Creates the action
*/
resource "genesyscloud_integration_action" "send_outbound_message" {
  name                   = var.action_name
  category               = var.action_category
  integration_id         = var.integration_id
  contract_input = jsonencode({
    "type" = "object",
    "required" = [
      "fromAddress",
      "toAddress",
      "textBody"
    ],
    "properties" = {
      "fromAddress" = {
        "type" = "string"
      },
      "toAddress" = {
        "type" = "string"
      },
      "toAddressMessengerType" = {
        "type" = "string",
        "default" = "sms"
      },
      "textBody" = {
        "type" = "string"
      }
    }
  })
  contract_output = jsonencode({
    "type" = "object",
    "properties" = {
      "conversationId" = {
        "type" = "string"
      }
    }
  })
  config_request {
    # Use '$${' to indicate a literal '${' in template strings. Otherwise Terraform will attempt to interpolate the string
    # See https://www.terraform.io/docs/language/expressions/strings.html#escape-sequences
    request_url_template = "/api/v2/conversations/messages/agentless"
    request_type         = "POST"
    request_template     = "{\n  \"fromAddress\": \"$${input.fromAddress}\",\n  \"toAddress\": \"$${input.toAddress}\",\n  \"toAddressMessengerType\": \"$${input.toAddressMessengerType}\",\n  \"textBody\": \"$${input.textBody}\"\n}"
    headers = {}
  }
  config_response {
    translation_map = {
      conversationId = "$.conversationId"
    }
    translation_map_defaults = {
      conversationId = "\"\""
    }
    success_template = "{\"conversationId\": $${conversationId}}"
  }
}
