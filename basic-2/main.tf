terraform {

  backend "s3" {
    bucket         = "jumpt57-terraform-sandbox-tf-state"
    key            = "tf-infra-basic-2/terraform.tfstate"
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

module "web_app_1" {
  source = "./module"

  domain           = "jumpt57.link"
  app_name         = "web-app-1"
  environment_name = "dev"
  instance_type    = "t2.micro"
  create_dns_zone  = true
}

# module "web_app_2" {
#   source = "./module"

#   domain           = "stage.jumpt57.link"
#   app_name         = "web-app-2"
#   environment_name = "stage"
#   instance_type    = "t2.micro"
#   create_dns_zone  = true
# }

