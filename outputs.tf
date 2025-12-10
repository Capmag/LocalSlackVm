output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.main.id
}

# Como aws_instance.web usa count = 0, puede no existir ninguna instancia.
# Usamos un condicional para evitar errores.
output "ec2_instance_id" {
  description = "ID of the EC2 instance (si existe)"
  value       = length(aws_instance.web) > 0 ? aws_instance.web[0].id : null
}

output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance (si existe)"
  value       = length(aws_instance.web) > 0 ? aws_instance.web[0].public_ip : null
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.main.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.main.arn
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2.id
}
