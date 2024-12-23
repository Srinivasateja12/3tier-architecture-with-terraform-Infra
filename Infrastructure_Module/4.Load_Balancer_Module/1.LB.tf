resource "azurerm_lb" "LB" {
  name                = var.LB-name
  location            = var.LB-rg-location
  resource_group_name = var.LB-rg-name

  frontend_ip_configuration {
    name                 = var.LB-Publicip-name
    public_ip_address_id = var.LB-Publicip-id
  }
}

resource "azurerm_lb_backend_address_pool" "LB_Pool" {
  loadbalancer_id = azurerm_lb.LB.id
  name            = var.LB-Pool-name
}

