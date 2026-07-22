output "tfstate_bucket_arn" {
  description = "collect the ARN of the terraform remote state s3 bucket"
  value       = aws_s3_bucket.tfstate_bucket.arn
}

output "tfstate_bucket_id" {
  value       = aws_s3_bucket.tfstate_bucket.id
  description = "collect the s3 bucket id"
}