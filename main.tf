# This file configures the AWS provider for Terraform

# Service provider config

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region  = var.aws_region
  profile = "Dev1" # Profile is defined in .aws/credentials
}


# Local Variables

locals {
  environment  = var.environment
  project_name = var.project_name

  # Tags applied to all resources
  tagging = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }
}