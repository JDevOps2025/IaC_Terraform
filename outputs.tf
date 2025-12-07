# These outputs are displayed after Terraform apply

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_eip" {
  description = "Elastic IP of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "web_server_ids" {
  description = "IDs of the EC2 web server instances"
  value       = [aws_instance.web_1.id, aws_instance.web_2.id]
}

output "web_server_private_ips" {
  description = "Private IP addresses of web servers"
  value       = [aws_instance.web_1.private_ip, aws_instance.web_2.private_ip]
}

output "web_server_public_ips" {
  description = "Public IP addresses of web servers"
  value       = [aws_instance.web_1.public_ip, aws_instance.web_2.public_ip]
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].dns_name : "ALB not enabled"
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].arn : "ALB not enabled"
}

output "web_server_sg_id" {
  description = "Security Group ID for web servers"
  value       = aws_security_group.web_server.id
}

output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = var.enable_alb ? aws_security_group.alb[0].id : "ALB not enabled"
}

output "access_instructions" {
  description = "Instructions on how to access the application"
  value       = var.enable_alb ? "Access your application at: http://${aws_lb.main[0].dns_name}" : "Access web servers directly at: http://${aws_instance.web_1.public_ip}"
}