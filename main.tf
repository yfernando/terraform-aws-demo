# Configure the AWS Provider
provider "aws" {
  region = "${var.region}"

  #assume_role = {
  #  role_arn = "${var.workspace_iam_roles[terraform.workspace]}"
  #}
}


terraform {
  required_version = ">= 1.2.0"
  
  backend "s3" {
    bucket = "cm.terraform.state"
    key    = "state/cm.terraform.tfstate"
    region = "eu-west-1"
  }
}
