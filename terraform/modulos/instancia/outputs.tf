# modulos/instancia/outputs.tf
output "mongodb_public_ip" {
  description = "IP pública de la instancia MongoDB"
  value       = aws_instance.mongodb_instance.public_ip
}
output "mongodb_instance_id" {
  description = "ID de la instancia MongoDB"
  value       = aws_instance.mongodb_instance.id
}

output "nodejs_public_ips" {
  description = "Lista de IPs públicas de las instancias Node.js"
  value       = [for instance in aws_instance.nodejs_instance : instance.public_ip]
}

output "mongodb_private_ip" {
  description = "IP privada de la instancia MongoDB"
  value       = aws_instance.mongodb_instance.private_ip
}

output "nodejs_private_ips" {
  description = "Lista de IPs privadas de las instancias Node.js"
  value       = [for instance in aws_instance.nodejs_instance : instance.private_ip]
}
output "nodejs_instance_ids" {
  description = "Lista de IDs de las instancias Node.js"
  value       = aws_instance.nodejs_instance[*].id
}


 
