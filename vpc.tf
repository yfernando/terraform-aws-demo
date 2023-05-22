 # Create the VPC
 resource "aws_vpc" "CM_main" {                             # Creating VPC
    cidr_block = "${var.main_vpc_cidr}"                     # Defining the CIDR block for VPC use 10.0.0.0/16
    tags = {
        Name = "CM-main-vpc"
    }
 }

 # Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "CM_igw" {                 # Creating Internet Gateway
    vpc_id =  aws_vpc.CM_main.id                            # vpc_id will be generated after we create VPC
    tags = {
        Name = "CM-igw"
    }
 }

 # Create Public Subnets
 resource "aws_subnet" "CM_subnet_public" {
    count = length(var.public_subnets)
    vpc_id =  aws_vpc.CM_main.id
    cidr_block = element(var.public_subnets, count.index)   # CIDR block for each public subnet
    availability_zone = element(var.azs, count.index)       # Creating a private subnet in each AZ for HA   
    tags = {
        Name = "CM-subnet-public-${count.index+1}"
    }   
 }

 # Create Private Subnets
 resource "aws_subnet" "CM_subnet_private" {
    count = length(var.private_subnets)
    vpc_id =  aws_vpc.CM_main.id
    cidr_block = element(var.private_subnets, count.index)  # CIDR block for each private subnet
    availability_zone = element(var.azs, count.index)       # Creating a private subnet in each AZ for HA   
    tags = {
        Name = "CM-subnet-private-${count.index+1}"
    } 

 }

 # Route table for Public Subnet
 resource "aws_route_table" "CM_rt_public" {                # Creating RT for Public Subnet
    vpc_id =  aws_vpc.CM_main.id
    route {
        cidr_block = "0.0.0.0/0"                            # Traffic from Public Subnet reaches Internet via Internet Gateway
        gateway_id = aws_internet_gateway.CM_igw.id
    }
    tags = {
        Name = "CM-public-rt"
    } 
 }

 # Route table for Private Subnet
 resource "aws_route_table" "CM_rt_private" {               # Creating RT for Private Subnet
    vpc_id = aws_vpc.CM_main.id
    route {
        cidr_block = "0.0.0.0/0"                            # Traffic from Private Subnet reaches Internet via NAT Gateway
        nat_gateway_id = aws_nat_gateway.CM_natgw.id
    }
    tags = {
        Name = "CM-private-rt"
    } 
 }

 # Route table association with Public Subnet
 resource "aws_route_table_association" "CM_rta_public" {
    count = length(var.public_subnets)
    subnet_id = element(aws_subnet.CM_subnet_public.*.id, count.index)
    route_table_id = aws_route_table.CM_rt_public.id
 }

# Route table Association with Private Subnet
 resource "aws_route_table_association" "CM_rta_private" {
    count = length(var.private_subnets)
    subnet_id = element(aws_subnet.CM_subnet_private.*.id, count.index)
    route_table_id = aws_route_table.CM_rt_private.id
 }

 resource "aws_eip" "CM_nat_eip" {
    vpc   = true
    tags = {
        Name = "CM-nat-eip"
    }
 }
 
 # Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "CM_natgw" {
    #count = length(var.public_subnets) 
    allocation_id = aws_eip.CM_nat_eip.id
    subnet_id = aws_subnet.CM_subnet_public.2.id
    #subnet_id = element(aws_subnet.CM_subnet_public.*.id, count.3)
    tags = {
        Name = "CM-natgw"
    }
 }