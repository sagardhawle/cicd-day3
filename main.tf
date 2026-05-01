
provider "aws" {
  region = var.region
}
resource "aws_security_group" "web_sg" {
  name = "web-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "cicd" {
  ami        = data.aws_ami.amazon_linux.id    
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    systemctl start nginx
    echo "<h1>CI/CD Terraform Website 🚀</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "CICD-Instance"
  }
}
