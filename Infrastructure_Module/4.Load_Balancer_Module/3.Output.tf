output "LB_id" {
  value = azurerm_lb.LB.id
}

output "LB_pool_id" {
  value = [azurerm_lb_backend_address_pool.LB_Pool.id]
}
