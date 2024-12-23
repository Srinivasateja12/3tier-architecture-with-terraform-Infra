

resource "azurerm_lb_probe" "LB_Probe" {
  loadbalancer_id = var.LB-id
  name            = var.LB-probe-name
  port            = var.LB-Probe-port
}

