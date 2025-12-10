terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


locals {
  project_name_full = "proyecto_final_raulrenteria-20490733"
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2      = var.localstack_endpoint
    s3       = var.localstack_endpoint
    dynamodb = var.localstack_endpoint
  }
}

# ==========================
# RED (VPC, Subnet, IGW, SG)
# ==========================

# VPC principal
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${local.project_name_full}-vpc"
    ProjectName = local.project_name_full
  }
}

# Subred principal
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = "${local.project_name_full}-subnet"
    ProjectName = local.project_name_full
  }
}

# Internet Gateway 
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${local.project_name_full}-igw"
    ProjectName = local.project_name_full
  }
}

# Security Group para EC2 (tráfico HTTP/80)
resource "aws_security_group" "ec2" {
  name        = "${local.project_name_full}-ec2-sg"
  description = "Security group for EC2 instance (HTTP)"
  vpc_id      = aws_vpc.main.id

  # Ingress HTTP (puerto 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress completo
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.project_name_full}-ec2-sg"
    ProjectName = local.project_name_full
  }
}

# ==========================
# CÓMPUTO (EC2 simulado)
# ==========================

# Definición de instancia EC2 
resource "aws_instance" "web" {
  count = 0 
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.main.id

  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name        = "${local.project_name_full}-ec2-instance"
    ProjectName = local.project_name_full
  }
}

# ==========================
# ALMACENAMIENTO (S3)
# ==========================

# Bucket S3 
resource "aws_s3_bucket" "main" {
  bucket = "proyecto-final-alumno-20490733"

  tags = {
    Name        = "proyecto-final-alumno-20490733"
    Environment = var.environment
    ProjectName = local.project_name_full
  }
}

# Habilitar versionado en el bucket S3
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Objeto index.html subido al bucket mediante Terraform
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.main.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  etag         = filemd5("${path.module}/index.html")
  content_type = "text/html"

  tags = {
    ProjectName = local.project_name_full
  }
}

# ==========================
# BASE DE DATOS (DynamoDB)
# ==========================

# Tabla DynamoDB llamada "Usuarios" con Partition Key "UserID"
resource "aws_dynamodb_table" "main" {
  name         = "Usuarios"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserID"

  attribute {
    name = "UserID"
    type = "S"
  }

  tags = {
    Name        = "Usuarios"
    Environment = var.environment
    ProjectName = local.project_name_full
  }
}
