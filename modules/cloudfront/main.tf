resource "aws_cloudfront_origin_access_control" "oac" {

    name                              = "website-oac"
    description                       = "OAC for private access bucket"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
  
}

resource "aws_cloudfront_distribution" "website" {

    enabled = true
   

    origin {
      domain_name = var.bucket_domain_name
      origin_id = "s3-origin"
      origin_path = var.origin_path

      origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    }

    default_root_object = "index.html"
    default_cache_behavior {
      target_origin_id = "s3-origin"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = [
        "GET",
        "HEAD"

      ]
      cached_methods = [
        "GET",
        "HEAD"
      ]
      forwarded_values {
        query_string = false

        cookies {
          forward = "none"
        }
      }
    }
    restrictions {
      geo_restriction {
        restriction_type = "none"
      }
    }
    viewer_certificate {
      cloudfront_default_certificate = true
    }
  
}