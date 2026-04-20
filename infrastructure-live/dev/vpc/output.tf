output "vpc_id" {
  value       = module.vpc.vpc_id # Assuming you use a VPC module
  description = "The ID of the VPC created in the network folder"
}
output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "The IDs of the public subnets created in the network folder"
}
output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "The IDs of the private subnets created in the network folder"
}
output "database_subnet_ids" {
  value       = module.vpc.database_subnet_ids
  description = "The IDs of the database subnets created in the network folder"
}
output "igw_id" {
  value       = module.vpc.igw_id
  description = "The ID of the Internet Gateway created in the network folder"
}
output "nat_eip_public_ip" {
  value       = module.vpc.nat_eip_public_ip
  description = "The public IP of the NAT EIP created in the network folder"
}
output "nat_gateway_id" {
  value       = module.vpc.nat_gateway_id
  description = "The ID of the NAT Gateway created in the network folder"
}
output "public_cidr" {
  value       = module.vpc.public_subnet_cidr_blocks
  description = "The CIDR block of the public subnets created in the network folder"
}
output "private_cidr" {
  value       = module.vpc.private_subnet_cidr_blocks
  description = "The CIDR block for the private subnets created in the network folder"
}
output "database_cidr" {
  value       = module.vpc.database_subnet_cidr_blocks
  description = "The CIDR block for the database subnets created in the network folder"
}