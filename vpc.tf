# VPC and subnets configuration
# This file creates the VPC, subnets across multiple availability zones, and enables DNS

# VPC Creation

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # DNS for hostnames and instances
  enable_dns_support   = true # DNS resolution

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-vpc"
    }
  )
}


# PUBLIC SUBNETS 

# Public Subnet 1 in Availability Zone 1
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true # Assign public IPs automatically

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-public-subnet-1"
      Type = "Public"
    }
  )
}

# Public Subnet 2 in Availability Zone 2
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true # Assign public IPs automatically

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-public-subnet-2"
      Type = "Public"
    }
  )
}


# PRIVATE SUBNETS

# Private Subnet 1 in Availability Zone 1
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-private-subnet-1"
      Type = "Private"
    }
  )
}

# Private Subnet 2 in Availability Zone 2
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-private-subnet-2"
      Type = "Private"
    }
  )
}