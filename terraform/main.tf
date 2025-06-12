# Configure the AWS Provider
#provider "aws" {
#  access_key = "${var.aws_access_key}"
#  secret_key = "${var.aws_secret_key}"
#  region     = "us-east-1"
#}

resource "terraform_data" "build_packer_image" {

  provisioner "local-exec" {
    command = <<EOT 
      cd ../packer && packer build ./node-nginx.json ! tee output.txt
  }

}
 