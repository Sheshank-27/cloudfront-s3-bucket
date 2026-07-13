resource "aws_s3_bucket" "website" {
    bucket = var.bucket_name
  
}

resource "aws_s3_bucket_versioning" "website" {
    bucket = aws_s3_bucket.website.id

    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_s3_bucket_public_access_block" "website" {
    bucket = aws_s3_bucket.website.id

    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
  
}