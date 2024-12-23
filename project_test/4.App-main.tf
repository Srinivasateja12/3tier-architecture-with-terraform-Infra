module "APP_LB" {
  source                       = "../Infrastructure_Module/10.Internal_LB_Module"
  internal-LB-name             = "APP-Load-Balancer"
  internal-LB-Rg-location      = module.RG01.RG_location
  internal-LB-Rg-name          = module.RG01.RG_name
  internal-LB-frontend-ip-name = "APP-Private-ip"
  internal-LB-subnet-id        = module.VNET01.SUB02_id
  internal-LB-private-ip       = "<Internal Load balancer Private IP>"
  internal-LB-Pool-name        = "Pool-APP"

  depends_on = [module.VNET01]
}

module "APP_LB_Probe1" {
  source                 = "../Infrastructure_Module/11.Internal_LB_Probe_Module"
  internal-LB-id         = module.APP_LB.internal_LB_id
  internal-LB-probe-name = "Tomcat-HP"
  internal-LB-Probe-port = 8080

  depends_on = [module.APP_LB]
}

module "APP_LB_Rule1" {
  source                       = "../Infrastructure_Module/12.Internal_LB_Rule_Module"
  internal-LB-id               = module.APP_LB.internal_LB_id
  internal-LB-Rule-name        = "APP-Rule1"
  internal-LB-Rule-Fornt-port  = 8080
  internal-LB-Rule-Back-port   = 8080
  internal-LB-Pool-id          = module.APP_LB.internal_LB_Pool_id
  internal-LB-frontend-ip-name = "APP-Private-ip"
  internal-LB-Probe-id         = module.APP_LB_Probe1.internal_LB_Probe_id

  depends_on = [module.APP_LB_Probe1]
}

module "APP_LB_Probe2" {
  source                 = "../Infrastructure_Module/11.Internal_LB_Probe_Module"
  internal-LB-id         = module.APP_LB.internal_LB_id
  internal-LB-probe-name = "SSH-HP"
  internal-LB-Probe-port = 22

  depends_on = [module.APP_LB]
}

module "APP-LB_Rule2" {
  source                       = "../Infrastructure_Module/12.Internal_LB_Rule_Module"
  internal-LB-id               = module.APP_LB.internal_LB_id
  internal-LB-Rule-name        = "APP-Rule2"
  internal-LB-Rule-Fornt-port  = 22
  internal-LB-Rule-Back-port   = 22
  internal-LB-Pool-id          = module.APP_LB.internal_LB_Pool_id
  internal-LB-frontend-ip-name = "APP-Private-ip"
  internal-LB-Probe-id         = module.APP_LB_Probe2.internal_LB_Probe_id

  depends_on = [module.APP_LB_Probe2]
}


module "APP_NSG" {
  source          = "../Infrastructure_Module/7.NSG_Module"
  NSG-name        = "APP-NSG"
  NSG-Rg-location = module.RG01.RG_location
  NSG-Rg-name     = module.RG01.RG_name
  sub-id          = module.VNET01.SUB02_id

  depends_on = [module.VNET01]
}

module "APP_NSG_Rule1" {
  source                              = "../Infrastructure_Module/8.NSG_Rule_Module"
  NSG-Rule-name                       = "allow-Tomcat-inbound"
  NSG-Rule-Priority                   = 100
  NSG-Rule-Direction                  = "Inbound"
  NSG-Rule-Access                     = "Allow"
  NSG-Rule-Source-port-range          = "*"
  NSG-Rule-Destination-port-range     = 8080
  NSG-Rule-Source-Address-Prefix      = "*"
  NSG-Rule-Destination-Address-Prefix = "*"
  NSG-Rule-Rg-name                    = module.RG01.RG_name
  NSG-name                            = module.APP_NSG.NSG_name

  depends_on = [module.APP_NSG]
}

module "APP_NSG_Rule2" {
  source                              = "../Infrastructure_Module/8.NSG_Rule_Module"
  NSG-Rule-name                       = "allow-SHH-inbound"
  NSG-Rule-Priority                   = 101
  NSG-Rule-Direction                  = "Inbound"
  NSG-Rule-Access                     = "Allow"
  NSG-Rule-Source-port-range          = "*"
  NSG-Rule-Destination-port-range     = 22
  NSG-Rule-Source-Address-Prefix      = "*"
  NSG-Rule-Destination-Address-Prefix = "*"
  NSG-Rule-Rg-name                    = module.RG01.RG_name
  NSG-name                            = module.APP_NSG.NSG_name

  depends_on = [module.APP_NSG]
}


data "azurerm_image" "APP_image" {
  resource_group_name = "LinuxImage_RG"
  name                = "tomcat-custom-image"
}

module "APP_VMSS" {
  source              = "../Infrastructure_Module/9.VMSS_Module"
  VMSS-name           = "APP-VirtualMachineScaleSet"
  VMSS-Rg-name        = module.RG01.RG_name
  VMSS-Rg-location    = module.RG01.RG_location
  Custom-image-id     = data.azurerm_image.APP_image.id
  VMSS-nic-name       = "APP-VMSS-NIC"
  VMSS-subnet-id      = module.VNET01.SUB02_id
  VMSS-backendpool-id = module.APP_LB.internal_LB_Pool_id

  VMSS-VMSS_Atuoscale-name = "APP-VMSS-Atuoscale"
  default-VMinVMSS         = 1
  min-VMinVMSS             = 1
  max-VMinVMSS             = 2

  depends_on = [module.VNET01, data.azurerm_image.APP_image]
}
