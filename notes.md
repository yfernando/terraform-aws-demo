

# Add subnets in each AZ with element() and length()
https://www.bogotobogo.com/DevOps/Terraform/Terraform-VPC-Subnet-ELB-RouteTable-SecurityGroup-Apache-Server-1.php

# NAT gateway use cases
https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-scenarios.html#public-nat-internet-access

# Deploying an AWS ECS Cluster of EC2 Instances With Terraform
https://medium.com/swlh/creating-an-aws-ecs-cluster-of-ec2-instances-with-terraform-85a10b5cfbe3


# Pre-requisites 
- Require AWS IAM API keys (access key and secret key) for creating and deleting permissions for all AWS resources.
- AWS credentials file set using ~/.aws/credentials
- Terraform should be installed on the machine.
- S3 bucket used to store remote state should be pre-created (see provider.tf)