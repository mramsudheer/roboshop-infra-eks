# VPC Definition
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc"
  })
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-public-subnet-${count.index}"
  })
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-private-subnet-${count.index}"
  })
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "aws_subnet" "database" {
  count             = length(var.database_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-database-subnet-${count.index}"
  })
  # lifecycle {
  #   prevent_destroy = true
  # }
}
# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-igw"
  })
}
# Public Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    #Gateway = aws_internet_gateway.igw.id
  }
  tags = merge(var.common_tags, { Name = "${var.project_name}-${var.environment}-public-rt" })
  # lifecycle {
  #   prevent_destroy = true
  # }
}
#Public route
# resource "aws_route" "public" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }
# Public route table association
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Static IP
resource "aws_eip" "nat" {
  count  = (var.nat_gateway_enable && var.static_ip == "") ? 1 : 0 #Executes only NATGateway is required
  domain = "vpc"
  tags   = merge(var.common_tags, { Name = "${var.project_name}-${var.environment}-nat-eip" })
}
# NATGateway
resource "aws_nat_gateway" "main" {
  count = var.nat_gateway_enable ? 1 : 0
  #allocation_id = aws_eip.nat.id
  allocation_id = var.static_ip != "" ? var.static_ip : aws_eip.nat[0].id
  # Logic: 
  # 1. If var.static_ip is a real ID (starts with eipalloc), use it.
  # Otherwise, use the EIP created by the module.
  #allocation_id = can(regex("^eipalloc-", var.static_ip)) ? var.static_ip : aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id # NAT must sit in a Public Subnet
  tags          = merge(var.common_tags, { Name = "${var.project_name}-${var.environment}-nat" })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.igw]
}
# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.main.id
  # }
  dynamic "route" {
    for_each = var.nat_gateway_enable ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[0].id
    }
  }
  tags = merge(var.common_tags, { Name = "${var.project_name}-${var.environment}-private-rt" })
  # lifecycle {
  #   prevent_destroy = true
  # }
}
# #Private route
# resource "aws_route" "private" {
#   count                  = var.nat_gateway_enable ? 1 : 0
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.main[0].id
# }
# Private route table association
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private[*].id)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
# --- Database Route Table ---
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.main.id
  # }
  dynamic "route" {
    for_each = var.nat_gateway_enable ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[0].id
    }
  }
  tags = merge(var.common_tags, { Name = "${var.project_name}-${var.environment}-database-rt" })
  # lifecycle {
  #   prevent_destroy = true
  # }
}
# #Database route
# resource "aws_route" "database" {
#   count                  = var.nat_gateway_enable ? 1 : 0
#   route_table_id         = aws_route_table.database.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.main[0].id
# }
# Database route table association
resource "aws_route_table_association" "database" {
  count          = length(aws_subnet.database[*].id)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}