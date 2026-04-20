resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}/${var.environment}/vpc_id"
  type  = "String"
  value = aws_vpc.main.id # Directly reference the resource
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.public[*].id)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.private[*].id)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project}/${var.environment}/database_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.database[*].id)
}

# Ensure you have created this resource in main.tf first!
# resource "aws_ssm_parameter" "database_subnet_group_name" {
#   name  = "/${var.project}/${var.environment}/database_subnet_group_name"
#   type  = "String"
#   value = aws_db_subnet_group.default[0].name 
# }
resource "aws_ssm_parameter" "igw_id" {
  name  = "/${var.project}/${var.environment}/igw_id"
  type  = "String"
  value = aws_internet_gateway.igw.id
}

resource "aws_ssm_parameter" "nat_gateway_ids" {
  count = var.nat_gateway_enable ? 1 : 0
  name  = "/${var.project}/${var.environment}/nat_gateway_ids"
  type  = "String"
  value = aws_nat_gateway.main[0].id
}
