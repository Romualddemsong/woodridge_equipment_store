# because bucket name must be globally unique we need to generate a random name reason why we are using the random resource block
resource "random_string" "random" {
  length  = 16
  upper   = false
  special = false
}



#provisioning an s3 bucket for storage
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-${random_string.random.result}"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}