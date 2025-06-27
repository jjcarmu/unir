output "instance_public_ip" {
  description = "IP pública de la instancia."
  value = module.instance.public_ip
}
