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

output "securitygroup_id" {
  value       = aws_security_group.instance.id
  description = "The id of the security group"
  sensitive   = false
}

output "instancepublic_ip" {
  value       = aws_instance.test_instance.public_ip
  description = "Public IP address of the instance"
  sensitive   = false
}

resource "aws_instance" "test_instance" {
  ami           = "ami-0cb117bb45fffa44c"
  instance_type = "t3.medium"
  iam_instance_profile = "AWSSupportPatchwork-SSMRoleForInstances"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = file("/terraform/userdata")

  tags = {
    Name = "testserver001"
    "awssupport:patchwork" = "patch"
  }
}

resource "aws_security_group" "instance" {
  name = "testinstanceSG"
  ingress {
    from_port = var.http_port
    to_port = var.http_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
