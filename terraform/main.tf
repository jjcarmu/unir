####################################################################################################
# CONFIGURACIÓN DE TERRAFORM PARA AWS 
####################################################################################################

# AWS Provider
provider "aws" {
  region = var.aws_region
}


# RECURSO PARA EJECUTAR PACKER Y GENERAR LA AMI
# Este recurso utiliza un comando local (en la maquina que ejecuta terraform init) para ejecutar Packer con las variables necesarias
# y generar la AMI basada en el archivo de configuración de Packer (node-nginx.json).
resource "null_resource" "packer_ami" {

  # local-exec ejecuta un comando en la máquina que ejecuta Terraform.
  provisioner "local-exec" {
    # Este comando invoca Packer para construir una AMI personalizada usando las variables y configuraciones proporcionadas.
    # usa solo ese provisioner y builder comandos-cloud-node-nginx.amazon-ebs.aws_builder
    #command = "packer build -only=comandos-cloud-node-nginx.amazon-ebs.aws_builder -var aws_access_key=${var.aws_access_key} -var aws_secret_key=${var.aws_secret_key} -var aws_session_token=${var.aws_session_token} -var-file=..\\packer\\variables.pkrvars.hcl modulos/packer/node-nginx.json"
    #command = "packer build modulos/packer/node-nginx.json"
    command = "packer build -var aws_access_key=${var.aws_access_key} -var aws_secret_key=${var.aws_secret_key} -var aws_session_token=${var.aws_session_token} modulos/packer/node-nginx.json && packer build -var aws_access_key=${var.aws_access_key} -var aws_secret_key=${var.aws_secret_key} -var aws_session_token=${var.aws_session_token} modulos/packer/mongodb.json"
  }
} 

module "red" {
  source = "./modulos/red"
}

module "instancia" {
  source            = "./modulos/instancia"
  instance_type     = var.instance_type
  mongodb_ami       = "ami-04ec84a0edadc1107"
  nodejs_ami        = "ami-0c69af4db824d6ea6"
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