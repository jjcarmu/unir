#  modulos/balanceador/variables.tf
variable "public_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "nodejs_instance_ids" {
  type        = list(string)
  description = "IDs de las instancias Node.js para balancear"
}
