/*
  Creates the queue
*/
resource "genesyscloud_routing_queue" "queue" {
  name          = "Switch Voice to Web Messaging"
  queue_flow_id = var.queue_flow_id
  members {
    user_id  = var.userId
  }
}
