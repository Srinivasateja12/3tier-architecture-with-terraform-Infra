resource "azurerm_virtual_network" "VNET" {
  name                = var.VNET-name
  location            = var.VNET-rg-location
  resource_group_name = var.VNET-rg-name
  address_space       = var.VNET-ip
}

resource "azurerm_subnet" "SUB01" {
  name                 = var.SUB01-name
  address_prefixes     = var.SUB01-ip
  resource_group_name  = var.SUB01-rg-name
  virtual_network_name = azurerm_virtual_network.VNET.name
}

resource "azurerm_subnet" "SUB02" {
  name                 = var.SUB02-name
  address_prefixes     = var.SUB02-ip
  resource_group_name  = var.SUB02-rg-name
  virtual_network_name = azurerm_virtual_network.VNET.name
}

