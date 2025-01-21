/*
  Creates the action
*/
resource "genesyscloud_integration_action" "update_aprticipant_data" {
  name                   = var.action_name
  category               = var.action_category
  integration_id         = var.integration_id
  contract_input = jsonencode({
    "type" = "object",
    "required" = [
      "conversationId",
      "participantId",
      "attributes"
    ],
    "properties" = {
      "conversationId" = {
        "type" = "string"
      },
      "participantId" = {
        "type" = "string"
      },
      "attributes" = {
        "type" = "string"
      }
    }
  })
  contract_output = jsonencode({
    "type" = "object",
    "properties" = { }
  })
  config_request {
    # Use '$${' to indicate a literal '${' in template strings. Otherwise Terraform will attempt to interpolate the string
    # See https://www.terraform.io/docs/language/expressions/strings.html#escape-sequences
    request_url_template = "/api/v2/conversations/callbacks/$${input.conversationId}/participants/$${input.participantId}/attributes"
    request_type         = "PATCH"
    request_template     = "{\n  \"attributes\": $${input.attributes}\n}"
    headers = {}
  }
  config_response {
    translation_map = {}
    translation_map_defaults = {}
    success_template = "$${rawResult}"
  }
}
