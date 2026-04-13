variable "aws_region" {
  description = "value of aws region"
  default     = "ap-south-1"
}

variable "ami_id" {
   description = "value of AMI"
  default     = "ami-05d2d839d4f73aafb"
}

variable "instance_type" {
    description =           "value of Intance type"
  default     = "t3.micro"
}