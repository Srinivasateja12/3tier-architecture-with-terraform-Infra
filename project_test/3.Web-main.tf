module "WEB_PIP" {
  source          = "../Infrastructure_Module/3.Public_ip_Module"
  PIP-name        = "WEB-Load_balancer-PIP"
  PIP-rg-name     = module.RG01.RG_name
  PIP-rg-location = module.RG01.RG_location

  depends_on = [module.VNET01]
}

module "WEB_LB" {
  source           = "../Infrastructure_Module/4.Load_Balancer_Module"
  LB-name          = "WEB-Load_balancer"
  LB-rg-location   = module.RG01.RG_location
  LB-rg-name       = module.RG01.RG_name
  LB-Publicip-name = module.WEB_PIP.PIP_name
  LB-Publicip-id   = module.WEB_PIP.PIP_id
  LB-Pool-name     = "Pool-WEB"

  depends_on = [module.WEB_PIP]
}

module "WEB_LB_Probe1" {
  source        = "../Infrastructure_Module/5.LB_Probe_Module"
  LB-id         = module.WEB_LB.LB_id
  LB-probe-name = "WEB-HTTP-HP"
  LB-Probe-port = 80

  depends_on = [module.WEB_LB]
}
module "WEB_LB_Rule1" {
  source             = "../Infrastructure_Module/6.LB_Rule_Module"
  LB-id              = module.WEB_LB.LB_id
  LB-Rule-name       = "WEB-Rule1"
  LB-Rule-rg-name    = module.RG01.RG_name
  LB-Rule-Fornt-port = 80
  LB-Rule-Back-port  = 80
  LB-Pool-id         = module.WEB_LB.LB_pool_id
  LB-Publicip-name   = module.WEB_PIP.PIP_name
  LB-Probe-id        = module.WEB_LB_Probe1.LB_Probe_id

  depends_on = [module.WEB_LB_Probe1]
}

module "WEB_LB_Probe2" {
  source        = "../Infrastructure_Module/5.LB_Probe_Module"
  LB-id         = module.WEB_LB.LB_id
  LB-probe-name = "WEB-SSH-HP"
  LB-Probe-port = 22

  depends_on = [module.WEB_LB]
}
module "WEB_LB_Rule2" {
  source             = "../Infrastructure_Module/6.LB_Rule_Module"
  LB-id              = module.WEB_LB.LB_id
  LB-Rule-name       = "WEB-Rule2"
  LB-Rule-rg-name    = module.RG01.RG_name
  LB-Rule-Fornt-port = 22
  LB-Rule-Back-port  = 22
  LB-Pool-id         = module.WEB_LB.LB_pool_id
  LB-Publicip-name   = module.WEB_PIP.PIP_name
  LB-Probe-id        = module.WEB_LB_Probe2.LB_Probe_id

  depends_on = [module.WEB_LB_Probe2]
}

module "WEB_LB_Probe3" {
  source        = "../Infrastructure_Module/5.LB_Probe_Module"
  LB-id         = module.WEB_LB.LB_id
  LB-probe-name = "WEB-Tomcat-HP"
  LB-Probe-port = 8080
}

module "WEB_LB_Rule3" {
  source             = "../Infrastructure_Module/6.LB_Rule_Module"
  LB-id              = module.WEB_LB.LB_id
  LB-Rule-name       = "WEB-Rule3"
  LB-Rule-rg-name    = module.RG01.RG_name
  LB-Rule-Fornt-port = 8080
  LB-Rule-Back-port  = 8080
  LB-Pool-id         = module.WEB_LB.LB_pool_id
  LB-Publicip-name   = module.WEB_PIP.PIP_name
  LB-Probe-id        = module.WEB_LB_Probe3.LB_Probe_id

  depends_on = [module.WEB_LB_Probe1]
}


module "WEB_NSG" {
  source          = "../Infrastructure_Module/7.NSG_Module"
  NSG-name        = "Web-NSG"
  NSG-Rg-name     = module.RG01.RG_name
  NSG-Rg-location = module.RG01.RG_location
  sub-id          = module.VNET01.SUB01_id

  depends_on = [module.VNET01]
}

module "WEB_NSG_Rule1" {
  source                              = "../Infrastructure_Module/8.NSG_Rule_Module"
  NSG-Rule-name                       = "allow-http-inbound"
  NSG-Rule-Priority                   = 100
  NSG-Rule-Direction                  = "Inbound"
  NSG-Rule-Access                     = "Allow"
  NSG-Rule-Source-port-range          = "*"
  NSG-Rule-Destination-port-range     = 80
  NSG-Rule-Source-Address-Prefix      = "*"
  NSG-Rule-Destination-Address-Prefix = "<SUBNET1 IP>"
  NSG-Rule-Rg-name                    = module.RG01.RG_name
  NSG-name                            = module.WEB_NSG.NSG_name

  depends_on = [module.WEB_NSG]
}

module "WEB_NSG_Rule2" {
  source                              = "../Infrastructure_Module/8.NSG_Rule_Module"
  NSG-Rule-name                       = "allow-ssh-inbound-for-myip"
  NSG-Rule-Priority                   = 101
  NSG-Rule-Direction                  = "Inbound"
  NSG-Rule-Access                     = "Allow"
  NSG-Rule-Source-port-range          = "*"
  NSG-Rule-Destination-port-range     = 22
  NSG-Rule-Source-Address-Prefix      = "<Your Public IP>"
  NSG-Rule-Destination-Address-Prefix = "<SUBNET2 IP>"
  NSG-Rule-Rg-name                    = module.RG01.RG_name
  NSG-name                            = module.WEB_NSG.NSG_name

  depends_on = [module.WEB_NSG]
}

module "WEB_NSG_Rule3" {
  source                              = "../Infrastructure_Module/8.NSG_Rule_Module"
  NSG-Rule-name                       = "allow-tomcat"
  NSG-Rule-Priority                   = 102
  NSG-Rule-Direction                  = "Inbound"
  NSG-Rule-Access                     = "Allow"
  NSG-Rule-Source-port-range          = "*"
  NSG-Rule-Destination-port-range     = 8080
  NSG-Rule-Source-Address-Prefix      = "<Your Public IP>"
  NSG-Rule-Destination-Address-Prefix = "<SUBNET2 IP>"
  NSG-Rule-Rg-name                    = module.RG01.RG_name
  NSG-name                            = module.WEB_NSG.NSG_name

  depends_on = [module.WEB_NSG]
}


data "azurerm_image" "Linux-image" {
  resource_group_name = "LinuxImage_RG"
  name                = "Linux_Image12"
}


module "WEB-VMSS" {
  source              = "../Infrastructure_Module/9.VMSS_Module"
  VMSS-name           = "WEB-VirtualMachineScaleSet"
  VMSS-Rg-name        = module.RG01.RG_name
  VMSS-Rg-location    = module.RG01.RG_location
  Custom-image-id     = data.azurerm_image.Linux-image.id
  VMSS-nic-name       = "WEB-VMSS-NIC"
  VMSS-subnet-id      = module.VNET01.SUB01_id
  VMSS-backendpool-id = module.WEB_LB.LB_pool_id

  VMSS-VMSS_Atuoscale-name = "WEB-VMSS-Atuoscale"
  default-VMinVMSS         = 1
  min-VMinVMSS             = 1
  max-VMinVMSS             = 2

  depends_on = [module.VNET01, data.azurerm_image.Linux-image]
}

