# modulos/instancia/main.tf
resource "aws_key_pair" "mean_keypair" {
  key_name   = "mean-keypair"
  public_key = var.public_key_path == "" ? file("~/.ssh/id_rsa.pub") : file(var.public_key_path)
}

resource "aws_instance" "mongodb_instance" {
  ami                    = var.mongodb_ami
  instance_type          = var.instance_type
  subnet_id              = element(var.public_subnet_ids, 0)
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.mean_keypair.key_name

  tags = {
    Name = "mongodb-instance"
  }
}


#segunda instancia
resource "aws_instance" "nodejs_instance" {
  count                  = 2
  ami                    = var.nodejs_ami
  instance_type          = var.instance_type
  subnet_id              = element(var.public_subnet_ids, count.index)
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.mean_keypair.key_name

  tags = {
    Name = "nodejs-instance-${count.index + 1}"
  }
}
