#required resources to fully setup a prod grade vpc
#resource 1 = VPC
resource "aws_vpc" "main" {
  cidr_block                = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "${var.environment_name}-vpc" })
  lifecycle {
    prevent_destroy = false
  }
}

#resource 2 = internet gateways

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.environment_name}-igw" })
  lifecycle {
    prevent_destroy = false  #should be enabled in a pod environment as this prevent accidental deletion
  }
}


#resource 3 = public subnet
resource "aws_subnet" "public" {
  for_each                = { for idx, az in local.azs : az => local.public_subnets[idx] }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "${var.environment_name}-public-${each.key}" })

}
#resource 4 private subnet
resource "aws_subnet" "private" {
  for_each                = { for idx, az in local.azs : az => local.private_subnets[idx] }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, { Name = "${var.environment_name}-private-${each.key}" })
}

#resource 5 =NAt gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  tags          = merge(var.tags, { Name = "${var.environment_name}-nat" })
  depends_on    = [aws_internet_gateway.igw]
}
#resource 6 = elastic IP for NAT
resource "aws_eip" "nat" {
  tags = merge(var.tags, { Name = "${var.environment_name}-eip" })
}

#resource 7 = public route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.environment_name}-public_rt" })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


}
#resource 8 = public route table association
resource "aws_route_table_association" "public_rt_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
  #tags           = merge(var.tags, { Name = "${var.environment_name}-public_rt_assoc" })
}
#resource 9 = private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.environment_name}-private_rt" })

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
#resource 10 = private route table association
resource "aws_route_table_association" "private_rt_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
 # tags           = merge(var.tags, { Name = "${var.environment_name}-private_rt_assoc" })
}