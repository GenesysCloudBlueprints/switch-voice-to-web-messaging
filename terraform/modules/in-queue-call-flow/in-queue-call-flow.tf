resource "genesyscloud_flow" "in_queue_call_flow" {
  filepath = "${path.module}/Switch to Web Messaging via SMS.yaml"
  substitutions = {
    flow_name                      = var.flow_name
    division                       = "Home"
    default_language               = "en-us"
    data_action_category           = var.data_action_category
    send_agentless_message_data_action = var.send_agentless_message_data_action
    sms_number                         = var.sms_number
  }
}