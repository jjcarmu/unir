provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "instance" {
  source                  = "./modules/instance"
  ami_id                  = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = module.vpc.public_subnets[0]
  security_group_ids      = [module.security_groups.app_sg_id]
  keypair_name            = "apollo"
}
