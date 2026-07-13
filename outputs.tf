output "bucket_name" {
  value = module.s3.bucket_id

}

output "cloudfront_url" {
  value = module.cloudfront.distribution_domain_name

}