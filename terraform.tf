terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
      bucket = "odoo-terraform-state-mgmt"
      key    = "odoo/terraform.tfstate"
      region = "us-east-1"
    }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
