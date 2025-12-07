# Configuration variables defined

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (Dev, QA, Prod)"
  type        = string
  default     = "Dev1"
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "webapp-cluster"
}


# VPC Configuration Variables

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet in AZ1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet in AZ2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet in AZ1"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet in AZ2"
  type        = string
  default     = "10.0.20.0/24"
}


# Availability Zones

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}


# EC2 Configuration Variables

variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t3.micro"
}

variable "web_server_count" {
  description = "Number of web servers to create (1 per AZ)"
  type        = number
  default     = 2
}

variable "web_server_name" {
  description = "Name prefix for web servers"
  type        = string
  default     = "web-server"
}


# ALB Configuration Variables

variable "enable_alb" {
  description = "Enable Application Load Balancer"
  type        = bool
  default     = true
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "web-alb"
}


# Security Configuration Variables

variable "allowed_http_cidr" {
  description = "CIDR blocks allowed to access HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Open to world for Dev; it should be restricted in production
}

variable "allowed_https_cidr" {
  description = "CIDR blocks allowed to access HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Open to world for Dev; it should be restricted in production
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"] # # Open to world for Dev; it should be restricted in production
}
