# Configure the AWS Provider
provider "aws" {
  region = "${var.region}"

  #assume_role = {
  #  role_arn = "${var.workspace_iam_roles[terraform.workspace]}"
  #}
}


terraform {
  backend "s3" {
    bucket = "cm.terraform.state"
    key    = "state/cm.terraform.tfstate"
    region = "eu-west-1"
  }
}
