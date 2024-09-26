provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_instance" {
  ami           = "ami-0cb117bb45fffa44c"
  instance_type = "t3.medium"
  iam_instance_profile = "AWSSupportPatchwork-SSMRoleForInstances"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = file("/terraform/userdata")

  tags = {
    Name = "testserver001"
  }
}

resource "aws_security_group" "instance" {
  name = "testinstanceSG"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
