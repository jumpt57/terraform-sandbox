terraform {
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

variable "env" {
  type = string
}

resource "aws_security_group" "sg" {
    name = "${var.env}-hello-world-sg"

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 8080
      protocol = "tcp"
      to_port = 8080
    }
}

resource "aws_instance" "hello_world_instance" {
  ami                    = "ami-0dfcb1ef8550277af"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello world !" > index.html
              python3 -m http.server 8080 &
              EOF
  tags = {
    Name = "${var.env}-hello-world"
  }
}


output "instance_ip_addr" {
  value = aws_instance.hello_world_instance.public_ip
}

