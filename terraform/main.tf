####################################################################################################
# CONFIGURACIÓN DE TERRAFORM PARA AWS 
####################################################################################################

# AWS Provider
provider "aws" {
  region = var.aws_region
}

#module "packer" {
#  source = "./modulos/packer"
#}

module "red" {
  source = "./modulos/red"
}

module "instancia" {
  source            = "./modulos/instancia"
  instance_type     = var.instance_type
  mongodb_ami       = var.mongodb_ami
  nodejs_ami        = var.nodejs_ami
  public_subnet_ids = module.red.public_subnet_ids
  security_group_id = module.red.security_group_id
}

module "balanceador" {
  source              = "./modulos/balanceador"
  public_subnet_ids   = module.red.public_subnet_ids
  security_group_id   = module.red.security_group_id
  vpc_id              = module.red.vpc_id
  nodejs_instance_ids = module.instancia.nodejs_instance_ids
}