resource "azurerm_lb_probe" "internal_LB_Probe" {
  loadbalancer_id = var.internal-LB-id
  name            = var.internal-LB-probe-name
  port            = var.internal-LB-Probe-port
}

