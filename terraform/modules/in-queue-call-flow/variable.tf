variable "flow_name" {
  type        = string
  description = "Name to assign to the In-Queue Call flow."
}

variable "data_action_category" {
  type        = string
  description = "The Data Action that is to be used in the Inbound Call Flow."
}

variable "send_agentless_message_data_action" {
  type        = string
  description = "The Data Action name that is to be used in the Inbound Call Flow."
}

variable "sms_number" {
  type        = string
  description = "Purchased SMS number with the format `+11234567890`"
}