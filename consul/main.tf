terraform {
  backend "s3" {
    bucket         = "jumpt57-terraform-sandbox-tf-state"
    key            = "tf-infra-consul/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}

module "consul" {
  source  = "hashicorp/consul/aws"
  version = "0.11.0"
  # insert the 4 required variables here
}