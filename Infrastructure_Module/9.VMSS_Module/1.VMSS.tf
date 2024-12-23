resource "azurerm_linux_virtual_machine_scale_set" "VMSS" {
  name                = var.VMSS-name
  resource_group_name = var.VMSS-Rg-name
  location            = var.VMSS-Rg-location
  sku                 = "Standard_B1s"
  instances           = 1

  upgrade_mode = "Automatic"

  disable_password_authentication = false
  admin_username                  = "adminteja"
  admin_password                  = "Password@1234"

  source_image_id = var.Custom-image-id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = var.VMSS-nic-name
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.VMSS-subnet-id
      load_balancer_backend_address_pool_ids = var.VMSS-backendpool-id
    }
  }

}

resource "azurerm_monitor_autoscale_setting" "VMSS_Atuoscale" {
  name                = var.VMSS-VMSS_Atuoscale-name
  resource_group_name = var.VMSS-Rg-name
  location            = var.VMSS-Rg-location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.VMSS.id

  #### Profile-1( Default Profile Block ) #####
  profile {
    name = "Default Profile"
    capacity {
      default = var.default-VMinVMSS
      minimum = var.min-VMinVMSS
      maximum = var.max-VMinVMSS
    }

    ### Percentage CPU Metric Rule Begins #####
    ### Scale-Out Rule  ####
    rule {
      scale_action {
        direction = "Increase" # Scale-out means always increase
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.VMSS.id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }
    }

    ### Scale-In Rule ####
    rule {
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.VMSS.id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }
    }
  }
}
