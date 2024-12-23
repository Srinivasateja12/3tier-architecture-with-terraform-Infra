resource "azurerm_lb_rule" "internal_LB_Rule" {
  loadbalancer_id                = var.internal-LB-id
  name                           = var.internal-LB-Rule-name
  protocol                       = "Tcp"
  frontend_port                  = var.internal-LB-Rule-Fornt-port
  backend_port                   = var.internal-LB-Rule-Back-port
  backend_address_pool_ids       = var.internal-LB-Pool-id
  frontend_ip_configuration_name = var.internal-LB-frontend-ip-name
  probe_id                       = var.internal-LB-Probe-id
}
