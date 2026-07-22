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
  bucket = "my-tf-test-bucket-r7dvua4lx4o493id-dev"
  key = "vpc/dev/terraform.tfstate"
  region = "us-east-2"
  encrypt = true
  use_lockfile = true
}


}

provider "aws"{

}







