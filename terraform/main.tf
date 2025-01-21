// Create a Data Action integration
module "data_action" {
  source                          = "git::https://github.com/GenesysCloudDevOps/public-api-data-actions-integration-module?ref=main"
  integration_name                = "Switch Voice to Web Messaging"
  integration_creds_client_id     = var.client_id
  integration_creds_client_secret = var.client_secret
}

// Create a Get All Customer Participant Data by ConversationId Data Action
module "get_cust_participant_data_data_action" {
  source             = "./modules/actions/get-customer-participant-data"
  action_name        = "Get All Customer Participant Data by ConversationId"
  action_category    = "${module.data_action.integration_name}"
  integration_id     = "${module.data_action.integration_id}"
}

// Create a Get Participant Id for Customer Data Action
module "get_participant_id_data_action" {
  source             = "./modules/actions/get-participant-id"
  action_name        = "Get Participant Id for Customer"
  action_category    = "${module.data_action.integration_name}"
  integration_id     = "${module.data_action.integration_id}"
}

// Create a Send Agentless Outbound Message Data Action
module "send_agentless_message_data_action" {
  source             = "./modules/actions/send-agentless-outbound-message"
  action_name        = "Send Agentless Outbound Message"
  action_category    = "${module.data_action.integration_name}"
  integration_id     = "${module.data_action.integration_id}"
}

// Create a Update Participant Data on Conversation Data Action
module "update_participant_data_data_action" {
  source             = "./modules/actions/update-participant-data"
  action_name        = "Update Participant Data on Conversation"
  action_category    = "${module.data_action.integration_name}"
  integration_id     = "${module.data_action.integration_id}"
}

// Create In-Queue Call Flow
module "in_queue_flow" {
  source                               = "./modules/in-queue-call-flow"
  flow_name                            = "Switch to Web Messaging via SMS"
  data_action_category                 = module.data_action.integration_name
  send_agentless_message_data_action   = module.send_agentless_message_data_action.action_name
  sms_number                           = var.sms_number
  depends_on                           = [ module.data_action, module.send_agentless_message_data_action ]
}

// Looks up the id of the user so we can associate it with the queue
data "genesyscloud_user" "user" {
  email = var.email
}

// Create Queue
module "queue" {
  source              = "./modules/queue"
  userId              = data.genesyscloud_user.user.id
  queue_flow_id       = module.in_queue_flow.flow_id
}

// Create Inbound Messge Flow
module "inbound_message_flow" {
  source                                  = "./modules/inbound-message-flow"
  flow_name                               = "Switch from Voice Channel with Context"
  data_action_category                    = module.data_action.integration_name
  get_cust_participant_data_data_action   = module.get_cust_participant_data_data_action.action_name
  get_participant_id_data_action          = module.get_participant_id_data_action.action_name
  update_participant_data_data_action     = module.update_participant_data_data_action.action_name
  queue_id                                = module.queue.queue_id
  depends_on                              = [ module.data_action, module.get_cust_participant_data_data_action, module.get_participant_id_data_action, module.update_participant_data_data_action ]
}

// Create Messenger Configuration
module "web_config" {
  source      = "./modules/webdeployments_configuration"
}

// Create Messenger Deployment
module "web_deploy" {
  source      = "./modules/webdeployments_deployment"
  flowId      = module.inbound_message_flow.flow_id
  configId    = module.web_config.config_id
  configVer   = module.web_config.config_ver
  depends_on  = [ module.inbound_message_flow ]
}