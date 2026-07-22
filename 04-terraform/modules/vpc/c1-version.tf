terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  random = {
    source  = "hashicorp/random"
    version = "~>3.9.0"
  }
  }
  
  backend "s3" {
  bucket = "my-tf-test-bucket-agmyrp9ewl2swp7aue"
  key = "vpc/dev/terraform.tfstate"
  region = "us-east-2"
  encrypt = true
  use_lockfile = true
}

}






