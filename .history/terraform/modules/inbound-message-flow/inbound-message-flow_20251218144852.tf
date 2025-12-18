resource "genesyscloud_flow" "inbound_message_flow" {
  filepath = "${path.module}/Switch from Voice Channel with Context.yaml"
  substitutions = {
    flow_name             = var.flow_name
    division              = "Home"
    default_language      = "en-us"
    queue_id              = var.queue_id
    data_action_category  = var.data_action_category
    get_cust_participant_data_data_action = var.get_cust_participant_data_data_action
    get_participant_id_data_action        = var.get_participant_id_data_action
    update_participant_data_data_action   = var.update_participant_data_data_action
  }
}