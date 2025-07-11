terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
