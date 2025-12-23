module "bigip_infra" {
  source           = "./modules/terraform-azurerm-f5-bigip-infra"
  byol_reg_key     = []
  f5_ssh_publickey = ""
  name_convention  = var.name_convention
}
