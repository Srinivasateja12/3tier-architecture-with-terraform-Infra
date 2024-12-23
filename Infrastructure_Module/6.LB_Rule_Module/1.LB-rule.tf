resource "azurerm_lb_rule" "LB_Rule" {
  loadbalancer_id                = var.LB-id
  name                           = var.LB-Rule-name
  protocol                       = "Tcp"
  frontend_port                  = var.LB-Rule-Fornt-port
  backend_port                   = var.LB-Rule-Back-port
  backend_address_pool_ids       = var.LB-Pool-id
  frontend_ip_configuration_name = var.LB-Publicip-name
  probe_id                       = var.LB-Probe-id
}
