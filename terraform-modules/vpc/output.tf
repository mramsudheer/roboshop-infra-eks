output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}
output "igw_id" {
  value = aws_internet_gateway.igw.id
}
output "nat_gateway_id" {
  description = "NATGateway ID(If created)"
  #value = aws_nat_gateway.main.id
  value = join("", aws_nat_gateway.main[*].id)
}
output "nat_public_ip" {
  value = join("", aws_nat_gateway.main[*].public_ip)
}
output "nat_eip_allocation_id" { #Eg: eipalloc-0a1b2c3d4e
  description = "The allocation ID of the Elastic IP"
  value       = join("", aws_eip.nat[*].id)
}
output "nat_eip_public_ip" { #Eg: 54.1.2.3
  description = "The public static IP address assigned to the NAT Gateway"
  # This returns the IP if created, or an empty string if skipped.
  value = join("", aws_eip.nat[*].public_ip)
}
output "project_name" {
  value = var.project_name
}
output "environment" {
  value = var.environment
}
output "common_tags" {
  value = var.common_tags
}
output "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}
output "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}
output "database_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the database subnets"
  value       = aws_subnet.database[*].cidr_block
}