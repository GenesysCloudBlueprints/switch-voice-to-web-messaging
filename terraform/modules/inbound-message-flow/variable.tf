variable "flow_name" {
  type        = string
  description = "Name to assign to the In-Queue Call flow."
}

variable "data_action_category" {
  type        = string
  description = "The Data Action that is to be used in the In-Queue Call Flow."
}

variable "get_cust_participant_data_data_action" {
  type        = string
  description = "The Data Action name that is to be used in the In-Queue Call Flow."
}

variable "get_participant_id_data_action" {
  type        = string
  description = "The Data Action name that is to be used in the In-Queue Call Flow."
}

variable "update_participant_data_data_action" {
  type        = string
  description = "The Data Action name that is to be used in the In-Queue Call Flow."
}

variable "queue_id" {
  type        = string
  description = "The Queue name that is to be used in the In-Queue Call Flow."
}