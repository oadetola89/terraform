provider "aws" {
  shared_config_files      = ["/root/.aws/config"]
  shared_credentials_files = ["/root/.aws/credentials"]
  profile                  = "default"
}

module "webserver" {
  source = "/modules/apps/webserver"
  instance_type  = "t3.medium"
  vpc_id  = "vpc-0dcc13858f0dc8a74"
  ami_id  = "ami-0e54eba7c51c234f6"
  security_group_name  = "testserver001SG"
  server_name  = "testserver001"
  subnet_name  = "Production-US-East-1-subnet-public1-us-east-1b"
  iam_role  = "AWSSupportPatchwork-SSMRoleForInstances"
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
