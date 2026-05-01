provider "aws" {
  region = var.region
}




resource "aws_instance" "cicd" {
  instance_type = var.instance_type
  key_name = var.key_name
  ami = data.aws_ami.amazon_linux.id
  
  tags = {
    Name = "CICD"
  }
}