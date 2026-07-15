output "vpc_id" {
    value =aws.vpc.id
    description = The ID of the vpc in use
}

output "public_subnet_ids" {
    value = [for s in aws_subnet.public: s.id]
    description = list of public subnet IDs
}

output "private_subnet_ids" {
     value =[for s in aws_subnet.private: s.id]
    description = list of all private subnet IDs
}

output "public_subnet_map" {
    value ={for az, subnet in aws_subnet.public: az => subnet.id}
    description = map of all public azs to subnets
}
