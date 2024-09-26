provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_instance" {
  ami           = "ami-0cb117bb45fffa44c"
  instance_type = "t3.medium"
  iam_instance_profile = "AWSSupportPatchwork-SSMRoleForInstances"
  security_groups =  "sg-0dc2a00131315cedc"

  tags = {
    Name = "testserver001"
  }
}
