resource "azurerm_public_ip" "PIP" {
  name                = var.PIP-name
  resource_group_name = var.PIP-rg-name
  location            = var.PIP-rg-location
  allocation_method   = "Static"

}
