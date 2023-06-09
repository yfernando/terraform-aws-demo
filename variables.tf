variable "region" {
    default = "eu-west-1"
}

variable "main_vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_subnets" {
    type = list
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

variable "private_subnets" {
    type = list
    default = ["10.0.11.0/24","10.0.22.0/24","10.0.33.0/24"]
}

variable "azs" {
    type = list
    default = ["eu-west-1a","eu-west-1b","eu-west-1c"]
}

#variable "image_url" {
#    default = "AWS_ACCOUNT_ID.dkr.ecr.region.amazonaws.com/nginx:latest"
#}

#variable "workspace_iam_roles" {
#  default = {
#    cm-admin    = "arn:aws:iam::ACCOUNT-ID:role/Terraform"
#  }
#}