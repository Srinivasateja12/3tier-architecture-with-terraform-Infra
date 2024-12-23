output "internal_LB_id" {
  value = azurerm_lb.internal_LB.id
}

output "internal_LB_Pool_id" {
  value = [azurerm_lb_backend_address_pool.internal_LB_Pool.id]
}

