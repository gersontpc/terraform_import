terraform {
  required_version = ">= 1.4.6"
  required_providers {
  aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65.0"
    }
  }
}

provider "aws" {
 region = "us-east-1"
}

# Backend
terraform {
  backend "s3" {
    bucket = "223111117520-tfstate"
    key    = "479610723/terraform-lab-import.tfstate"
    region = "us-east-1"
  }
}