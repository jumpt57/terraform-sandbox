terraform {

  backend "s3" {
    bucket         = "jumpt57-terraform-sandbox-tf-state"
    key            = "tf-infra-workspaces/terraform.tfstate"
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

locals {
  environment_name = terraform.workspace
}

module "web_app_1" {
  source = "../modules/web-app"

  domain           = "jumpt57.link"
  app_name         = "web-app-1"
  environment_name = local.environment_name
  instance_type    = "t2.micro"
}
