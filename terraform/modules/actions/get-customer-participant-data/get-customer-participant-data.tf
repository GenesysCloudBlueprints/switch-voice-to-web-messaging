/*
  Creates the action
*/
resource "genesyscloud_integration_action" "get_cust_participant_data" {
  name                   = var.action_name
  category               = var.action_category
  integration_id         = var.integration_id
  contract_input = jsonencode({
    "type" = "object",
    "properties" = {
      "conversationId" = {
        "type" = "string"
      }
    }
  })
  contract_output = jsonencode({
    "type" = "object",
    "properties" = {
      "jsonAttributes" = {
        "type" = "string"
      }
    }
  })
  config_request {
    # Use '$${' to indicate a literal '${' in template strings. Otherwise Terraform will attempt to interpolate the string
    # See https://www.terraform.io/docs/language/expressions/strings.html#escape-sequences
    request_url_template = "/api/v2/conversations/$${input.conversationId}"
    request_type         = "GET"
    request_template     = "$${input.rawRequest}"
    headers = {}
  }
  config_response {
    translation_map = {
      attributes = "$.participants[?(@.purpose == \"customer\")].attributes"
    }
    translation_map_defaults = {}
    success_template = "{\"jsonAttributes\": \"$esc.jsonEncode($${successTemplateUtils.firstFromArray(\"$${attributes}\")})\"}"
  }
}
