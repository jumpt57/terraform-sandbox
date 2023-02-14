terraform {

  backend "s3" {
    bucket         = "jumpt57-terraform-sandbox-tf-state"
    key            = "tf-infra-dns/terraform.tfstate"
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


resource "aws_route53_zone" "primary" {
  count = var.create_dns_zone ? 1 : 0
  name = var.domain
}

data "aws_route53_zone" "primary" {
  count = var.create_dns_zone ? 0 : 1
  name  = var.domain
}

locals {
  dns_zone_id = var.create_dns_zone ? aws_route53_zone.primary[0].zone_id : data.aws_route53_zone.primary[0].zone_id
  name_servers = var.create_dns_zone ? aws_route53_zone.primary[0].name_servers : data.aws_route53_zone.primary[0].name_servers
}


resource "aws_route53domains_registered_domain" "jumpt57_link" {
  domain_name = var.domain

  dynamic "name_server" {
    for_each = sort(local.name_servers)
    content {
      name = name_server.value
    }
  }
}
