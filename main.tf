provider "aws" {
  shared_config_files      = ["/root/.aws/config"]
  shared_credentials_files = ["/root/.aws/credentials"]
  profile                  = "default"
}

variable "http_port" {
  description = "port http service listens on"
  type        = number
  default     = 80
}

variable "vpc_id" {
  default     = "vpc-0dcc13858f0dc8a74"
}

output "securitygroup_id" {
  value       = aws_security_group.test.id
  description = "The id of the security group"
  sensitive   = false
}

data "aws_vpc" "default" {
  id  = "vpc-0dcc13858f0dc8a74"
}

data "aws_subnet" "default" {
  filter {
    name  = "vpc-id"
    values  = [var.vpc_id]
  }

  filter {
    name = "tag:Name"
    values  = ["Production-US-East-1-subnet-public1-us-east-1b"]
  }
}

output "instancepublic_ip" {
  value       = aws_instance.test_instance.public_ip
  description = "Public IP address of the instance"
  sensitive   = false
}

resource "aws_security_group" "test" {
  name = "testinstance-test0001-SG"
  vpc_id  = var.vpc_id

  ingress {
    from_port = var.http_port
    to_port = var.http_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "primary" {
  subnet_id   = data.aws_subnet.default.id
  security_groups  = [aws_security_group.test.id]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "test_instance" {
  ami           = "ami-0e54eba7c51c234f6"
  instance_type = "t3.medium"
  iam_instance_profile = "AWSSupportPatchwork-SSMRoleForInstances"
  key_name = "myrsakey"

  user_data = file("/terraform/userdata")

  tags = {
    Name = "testserver001"
    "awssupport:patchwork" = "patch"
  }

  network_interface {
    network_interface_id = aws_network_interface.primary.id
    device_index         = 0
  }
}

terraform {
  backend "s3" {
    bucket  = "adetoolu-terraform-files"
    key  = "workspace_instance/terraform.tfstate"
    region  = "us-east-1"
    dynamodb_table  = "terraform_state-locks"
    encrypt  = true
  }
}
