module "RG01" {
  source      = "../Infrastructure_Module/1.Resource_Group_Module"
  RG-name     = "Project-RG"
  RG-location = "Central India"
}

module "VNET01" {
  source           = "../Infrastructure_Module/2.Virtual_Network_Module"
  VNET-name        = "Project-Vnet"
  VNET-rg-location = module.RG01.RG_location
  VNET-rg-name     = module.RG01.RG_name
  VNET-ip          = ["<VNET IP>"]

  SUB01-name    = "WEB-SUBNET"
  SUB01-ip      = ["<SUBNET1 IP>"]
  SUB01-rg-name = module.RG01.RG_name

  SUB02-name    = "APP-SUBNET"
  SUB02-ip      = ["<SUBNET2 IP>"]
  SUB02-rg-name = module.RG01.RG_name

  depends_on = [module.RG01]
}



