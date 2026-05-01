provider "aws" {
  region = var.region
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cicd" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]
user_data = <<-EOF
  #!/bin/bash
  yum update -y
  amazon-linux-extras install nginx1 -y
  systemctl start nginx
  systemctl enable nginx

  cat <<HTML > /usr/share/nginx/html/index.html
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <title>CI/CD Project</title>
      <style>
          body {
              text-align: center;
              font-family: Arial, sans-serif;
              background-color: #0f172a;
              color: white;
          }
          h1 {
              margin-top: 50px;
              font-size: 40px;
          }
          .logos img {
              width: 120px;
              margin: 20px;
          }
      </style>
  </head>
  <body>

      <h1>Hey Sagar 🚀</h1>
      <p>Deployed using Terraform + GitHub CI/CD + AWS</p>

      <div class="logos">
          <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg">
          <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg">
          <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Octicons-mark-github.svg">
      </div>

  </body>
  </html>
  HTML
EOF
}