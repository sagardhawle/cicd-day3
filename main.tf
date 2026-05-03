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
            color: white;
            transition: background-color 1s ease;
        }

        h1 {
            margin-top: 50px;
            font-size: 40px;
        }

        .logos img {
            width: 100px;
            margin: 20px;
            transition: transform 0.3s;
        }

        .logos img:hover {
            transform: scale(1.2);
        }
    </style>

    <script>
        const colors = ["#0f172a", "#1e293b", "#334155", "#0ea5e9", "#9333ea"];
        let index = 0;

        setInterval(() => {
            document.body.style.backgroundColor = colors[index];
            index = (index + 1) % colors.length;
        }, 2000);
    </script>
</head>

<body>

    <h1>Hey Sagar 🚀</h1>
    <p>Deployed using Terraform + GitHub CI/CD + AWS</p>

    <div class="logos">
        <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" alt="AWS">
        <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg" alt="Terraform">
        <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" alt="GitHub">
        <img src="https://git-scm.com/images/logos/downloads/Git-Icon-1788C.png" alt="Git">
        <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" alt="CI/CD">
    </div>

</body>
</html>
HTML

EOF


tags = {
  Name = "demo-ec2"
}
}
