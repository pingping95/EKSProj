provider "aws" {
  region                  = var.region
  shared_credentials_file = var.cred_file
  profile                 = var.profile_name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.6"
    }
  }

  backend "s3" {
    bucket                  = "taehun-test-an2-tfstate"
    key                     = "an2/eks/test.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "sre5_taehun"
    shared_credentials_file = "~/.aws/credendials"
  }
}