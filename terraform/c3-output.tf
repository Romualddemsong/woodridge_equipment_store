##output block in tf is used to print values of succesful terraform apply. 
##it help to quickly capture this like id arn etc of resources created and easlily reuse them


output "s3_bucket_name"{
    value = aws_s3_bucket.example.bucket.id
    Description ="collect the bucket id"
}

output "s3_bucket_name"{
    value = aws_s3_bucket.example.bucket.arn
    Description ="collect the bucket arn"
}