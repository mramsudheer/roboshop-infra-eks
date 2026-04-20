variable "vpc_cidr" {
  type = string
  description = "The CIDR block for VPC"
}
# FOR PUBLIC SUBNET
variable "public_subnet_cidrs" {
  type = list(string)
  description = "List of CIDR blocks for Public Subnet"
}
# FOR PRIVATE SUBNET
variable "private_subnet_cidrs" {
  type = list(string)
  description = "List if CIDR blocks for Private Subnet"
}
# FOR DATABASE SUBNET
variable "database_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for database subnets"
}
variable "azs" {
  type        = list(string)
  description = "List of Availability Zones (e.g., ['us-east-1a', 'us-east-1b'])"
}
variable "nat_gateway_enable" {
  type        = bool
  description = "NATGateway required or not"
  default     = false
}
variable "static_ip" {
  type        = string
  description = "Optional: Existing Static IP"
  default     = ""
}
variable "project_name" {
  type = string
}
variable "environment" {
  type = string
  validation {
    condition = contains(["dev", "qa", "uat", "prod"],var.environemnt)
     error_message = "Environments should be one of dev, qa, uat or prod"
  }
}
variable "common_tags" {
  type        = map(string)
  description = "Common Tags for all resources"
  default     = {}
}
variable "vpc_tags" {
    type = map
    default = {}
}
variable "igw_tags" {
    type = map
    default = {}
}
variable "public_subnet_tags" {
    default = {}
    type = map
}
variable "private_subnet_tags" {
    default = {}
    type = map
}
variable "database_subnet_tags" {
    default = {}
    type = map
}
variable "public_route_table_tags" {
    default = {}
    type = map
}
variable "private_route_table_tags" {
    default = {}
    type = map
}
variable "database_route_table_tags" {
    default = {}
    type = map
}
variable "eip_tags" {
    default = {}
    type = map
}
variable "nat_gateway_tags" {
    default = {}
    type = map
}
variable "is_peering_required" {
    default = false
    type = bool
}