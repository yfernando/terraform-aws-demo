 # Create the VPC
 resource "aws_vpc" "CM_main" {                 # Creating VPC
    cidr_block       = "${var.main_vpc_cidr}"   # Defining the CIDR block use 10.0.0.0/24
    tags = {
        Name = "CM-main-vpc"
    }
 }

 # Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "CM_igw" {     # Creating Internet Gateway
    vpc_id =  aws_vpc.CM_main.id                # vpc_id will be generated after we create VPC
 }

 # Create a Public Subnets
 resource "aws_subnet" "CM_subnet_public" {     # Creating Public Subnet
   vpc_id =  aws_vpc.CM_main.id
   cidr_block = "${var.public_subnet}"          # CIDR block of public subnet
 }

 # Create a Private Subnet                      # Creating Private Subnet
 resource "aws_subnet" "CM_subnet_private" {
   vpc_id =  aws_vpc.CM_main.id
   cidr_block = "${var.private_subnet}"        # CIDR block of private subnets
 }

 # Route table for Public Subnet
 resource "aws_route_table" "CM_rt_public" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.CM_main.id
    route {
        cidr_block = "0.0.0.0/0"                # Traffic from Public Subnet reaches Internet via Internet Gateway
        gateway_id = aws_internet_gateway.CM_igw.id
    }
 }

 # Route table for Private Subnet
 resource "aws_route_table" "CM_rt_private" {   # Creating RT for Private Subnet
   vpc_id = aws_vpc.CM_main.id
   route {
        cidr_block = "0.0.0.0/0"                # Traffic from Private Subnet reaches Internet via NAT Gateway
        nat_gateway_id = aws_nat_gateway.CM_natgw.id
   }
 }

 # Route table association with Public Subnet
 resource "aws_route_table_association" "CM_rt_public" {
    subnet_id = aws_subnet.CM_subnet_public.id
    route_table_id = aws_route_table.CM_rt_public.id
 }

# Route table Association with Private Subnet
 resource "aws_route_table_association" "CM_rt_private" {
    subnet_id = aws_subnet.CM_subnet_private.id
    route_table_id = aws_route_table.CM_rt_private.id
 }

 resource "aws_eip" "CM_nat_eip" {
   vpc   = true
 }
 
 # Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "CM_natgw" {
   allocation_id = aws_eip.CM_nat_eip.id
   subnet_id = aws_subnet.CM_subnet_public.id
 }