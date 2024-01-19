terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"  # aws provider virsion , not terraform version
    }
  }

  backend "s3" {
    bucket = "remote-state-backend-terra"
    key    = "provisioner"
    region = "us-east-1"
    dynamodb_table = "remote-lock-terra"
  }
}

provider "aws" {
  region = "us-east-1"
}

 