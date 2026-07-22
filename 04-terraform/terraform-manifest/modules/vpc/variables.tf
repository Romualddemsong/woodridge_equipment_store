variable "environment_name" {
  description = " environment for resource tagging"
  type        = string
  default     = "Dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Global tags that applies to all resource"
  type        = map(string)
  default = {
    environment = "Dev"
    project     = "equipement_store"
    owner       = "infra team"
    ManagedBy   = "Dev team"
    CostCenter  = "IT"
  }
}

variable "subnet_newbits" {
  description = " number of new bits that can be added to our VPC CIDR to generate new subnets"
  type        = number
  default     = 8
}