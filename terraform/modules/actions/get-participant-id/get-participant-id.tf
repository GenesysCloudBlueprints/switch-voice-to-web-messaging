/*
  Creates the action
*/
resource "genesyscloud_integration_action" "get_participant_id" {
  name                   = var.action_name
  category               = var.action_category
  integration_id         = var.integration_id
  contract_input = jsonencode({
    "type" = "object",
    "required" = [ "conversationId" ],
    "properties" = {
      "conversationId" = {
        "type" = "string"
      }
    }
  })
  contract_output = jsonencode({
    "type" = "object",
    "properties" = {
      "customerParticipantId" = {
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
      participantIdArray = "$.participants[?(@.purpose ==\"customer\")].id"
    }
    translation_map_defaults = {
      participantIdArray = "[\"\"]"
    }
    success_template = "{\n\"customerParticipantId\": $${successTemplateUtils.firstFromArray(\"$${participantIdArray}\", \"$esc.quote $esc.quote\")}\n}"
  }
}
