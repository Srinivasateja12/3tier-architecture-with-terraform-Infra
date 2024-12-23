resource "azurerm_lb" "internal_LB" {
  name                = var.internal-LB-name
  location            = var.internal-LB-Rg-location
  resource_group_name = var.internal-LB-Rg-name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = var.internal-LB-frontend-ip-name
    subnet_id                     = var.internal-LB-subnet-id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.internal-LB-private-ip
  }
}

resource "azurerm_lb_backend_address_pool" "internal_LB_Pool" {
  loadbalancer_id = azurerm_lb.internal_LB.id
  name            = var.internal-LB-Pool-name
}



