#required resources to fully setup a prod grade vpc
#resource 1 = VPC
resource "aws_vpc" "main"{
    cidr = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags =merge(var.tags, {Name = "${var.environment_name}-vpc"})
}
#resource 2 = internet gateways
#resource 3 = public subnet
#resource 4 private subnet
#resource 5 =NAt gateway
#resource 6 = elastic IP for NAT
#resource 7 = public route tables
#resource 8 = public route table association
#resource 9 = private route table
#resource 10 = private route table association