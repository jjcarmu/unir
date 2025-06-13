############################################
# AWS
######º#####################################

variable "aws_region" {
  default     = "us-east-1"
  description = "Región de AWS"
}

variable "ami_name" {
  default     = "ami-00ca0754cabb20b45"
  description = "Nombre base de la AMI"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Tipo de instancia EC2"
}

variable "instance_name" {
  default     = "node-nginx-actividad2"
  description = "Nombre de la instancia"
}


### CREDENCIALES
variable "key_name" {
  description = "Nombre del par de claves para acceder a la instancia"
}

variable "aws_access_key" {
  description = "Clave de acceso de AWS"
}

variable "aws_secret_key" {
  description = "Clave secreta de AWS"
}

variable "aws_session_token" {
  description = "Token de sesión de AWS"
}

