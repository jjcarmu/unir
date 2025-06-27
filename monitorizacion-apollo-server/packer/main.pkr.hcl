packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "apollo_elk" {
  access_key              = var.aws_access_key
  secret_key              = var.aws_secret_key
  region                  = var.aws_region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  instance_type           = "t2.micro"
  ssh_username            = "ubuntu"
  ami_name                = "${var.ami_name}"
  tags = {
    Name        = "${var.ami_name}"
  }
}

build {
  name    = "build-aws"
  sources = ["source.amazon-ebs.apollo_elk"]

  provisioner "file" {
   source      = "app"
   destination = "/tmp"
  }

  provisioner "file" {
    source      = "nginx/default.conf"
    destination = "/tmp/default.conf"
  }

  provisioner "file" {
    source      = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }
}
