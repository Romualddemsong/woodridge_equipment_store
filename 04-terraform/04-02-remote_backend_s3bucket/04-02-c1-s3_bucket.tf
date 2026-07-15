# Because S3 bucket names must be globally unique, we generate a random
# suffix to reduce the chance of name collisions.
resource "random_string" "random" {
  length  = 16
  upper   = false
  special = false
}

# Provision an S3 bucket to store the Terraform state file
resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "my-tf-test-bucket-${random_string.random.result}"

  lifecycle {
    # In production, this should be true to prevent accidental deletion
    # of the Terraform state bucket.
    prevent_destroy = false
  }

  tags = {
    Name        = "tfstate-${var.environment_name}-${var.aws_region}-${random_string.random.result}"
    Environment = var.environment_name
    Project     = "woodbridge sales"
    Purpose     = "terraform remote-backend"
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_encryption" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      # kms_master_key_id = aws_kms_key.mykey.arn  use this only if you are personally using kms encryption to encrypt data
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate_block_public_access" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}