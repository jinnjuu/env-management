terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.1"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Terraform = "True"
      Owner   = "jinnjuu"
    }
  }
}
