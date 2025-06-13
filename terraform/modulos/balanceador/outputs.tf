# modules/loadbalancer/outputs.tf
output "lb_dns_name" {
  description = "DNS del balanceador de carga"
  value       = aws_lb.mean-lb.dns_name
}

output "lb_arn" {
  description = "ARN del balanceador"
  value       = aws_lb.mean-lb.arn
}
