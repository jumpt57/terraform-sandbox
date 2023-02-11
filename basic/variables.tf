variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  default     = "ami-0aa7d40eeae50c9a9" # Ubuntu 20.04 LTS // us-east-1
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "ec2 instance name"
  type        = string
}

variable "domain" {
  description = "domain for website"
  type        = string
}