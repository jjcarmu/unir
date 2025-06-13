# modulos/red/outputs.tf
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.mean_vpc.id
}

output "public_subnet_ids" {
  description = "IDs de las subredes públicas"
  value       = aws_subnet.public_subnets[*].id
}

output "security_group_id" {
  description = "ID del grupo de seguridad"
  value       = aws_security_group.allow_ssh_http_mongo.id
}
