#required resources to fully setup a prod grade vpc
#resource 1 = VPC
resource "aws_vpc" "main"{
    cidr = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags =merge(var.tags, {Name = "${var.environment_name}-vpc"})
}

#resource 2 = internet gateways

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.main.id
    tags = merge(var.tags, {Name = "${var.environment_name}-igw"})
lifecycle {
    prevent_destroy = true
}
}

#resource 3 = public subnet
resource "aws_subnet" "public" {
for_each = {for idx, az in local.azs : az => local.public_subnets[idx] }
  vpc_id     = aws_vpc.main.id
  cidr_block =each.value 
  availability_zone = each.key
  map_public_ip_on_launch = true
tags = merge(var.tags, {Name = "${var.environment_name}-public-${each.key}"})

}
#resource 4 private subnet

resource "aws_subnet" "private" {
for_each = {for idx, az in local.azs : az => local.private_subnets[idx] }
  vpc_id     = aws_vpc.main.id
  cidr_block =each.value 
  availability_zone = each.key
  map_public_ip_on_launch = false
tags = merge(var.tags, {Name = "${var.environment_name}-private-${each.key}"})
#resource 5 =NAt gateway
#resource 6 = elastic IP for NAT
#resource 7 = public route tables
#resource 8 = public route table association
#resource 9 = private route table
#resource 10 = private route table association