variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  description = "LocalStack endpoint URL"
  type        = string
  default     = "http://localhost:4566"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "localstack-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instance (LocalStack uses a dummy AMI)"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}
