resource "azurerm_network_security_group" "NSG" {
  name                = var.NSG-name
  location            = var.NSG-Rg-location
  resource_group_name = var.NSG-Rg-name
}

resource "azurerm_subnet_network_security_group_association" "NSG-SUB" {
  subnet_id                 = var.sub-id
  network_security_group_id = azurerm_network_security_group.NSG.id
}