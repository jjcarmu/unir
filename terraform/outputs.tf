# output.tf
# Salidas del modulo red 
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.red.vpc_id
}

output "public_subnet_ids" {
  description = "IDs de las subredes públicas"
  value       = module.red.public_subnet_ids
}

output "security_group_id" {
  description = "ID del grupo de seguridad"
  value       = module.red.security_group_id
}

#  Salidas del modulo instancia 
output "mongodb_public_ip" {
  description = "IP pública de la instancia MongoDB"
  value       = module.instancia.mongodb_public_ip
}

output "nodejs_public_ips" {
  value = module.instancia.nodejs_public_ips
}

output "mongodb_private_ip" {
  description = "IP privada de la instancia MongoDB"
  value       = module.instancia.mongodb_private_ip
}

output "nodejs_private_ips" {
  value = module.instancia.nodejs_private_ips
}

# --- Salidas del modulo balanceador ---
output "lb_dns_name" {
  description = "DNS del balanceador de carga"
  value       = module.balanceador.lb_dns_name
}
