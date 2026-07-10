##output block in tf is used to print values of succesful terraform apply. 
##it help to quickly capture this like id arn etc of resources created and easlily reuse them


output "s3_bucket_id_name" {
  value       = aws_s3_bucket.example.id
  description = "collect the bucket id"
}

output "s3_bucket_arn_name" {
  value       = aws_s3_bucket.example.arn
  description = "collect the bucket arn"
}