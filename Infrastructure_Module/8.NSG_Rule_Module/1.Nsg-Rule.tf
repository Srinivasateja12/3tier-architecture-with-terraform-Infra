resource "azurerm_network_security_rule" "NSG_Rule" {
  name                        = var.NSG-Rule-name
  priority                    = var.NSG-Rule-Priority
  direction                   = var.NSG-Rule-Direction
  access                      = var.NSG-Rule-Access
  protocol                    = "Tcp"
  source_port_range           = var.NSG-Rule-Source-port-range
  destination_port_range      = var.NSG-Rule-Destination-port-range
  source_address_prefix       = var.NSG-Rule-Source-Address-Prefix
  destination_address_prefix  = var.NSG-Rule-Destination-Address-Prefix
  resource_group_name         = var.NSG-Rule-Rg-name
  network_security_group_name = var.NSG-name
}