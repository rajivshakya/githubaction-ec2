terraform {
  backend "s3" {
    bucket         = "mybucket-terraform-state-file"
    key            = "env/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "aws-key"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("nginx.sh")
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    encrypted = true
  }

  tags = {
    Name : "Web-Server"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "nginx-sg"
  description = "Allow HTTP and restricted SSH"

  # 🌐 HTTP (public website ke liye open)
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ✔ required
  }

  # 🔐 SSH (sirf tumhare IP se)
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["106.219.150.52/32"]
  }

  # 📤 Outbound (generally open rehta hai)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
