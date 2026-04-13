provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name : "Web-Server"
  }
}