
module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}

module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_domain_name = module.s3.bucket_domain_name
  bucket_arn         = module.s3.bucket_arn
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = ["s3:GetObject"]

    resources = [
      "${module.s3.bucket_arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${module.cloudfront.distribution_id}"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = module.s3.bucket_id
  policy = data.aws_iam_policy_document.bucket_policy.json
}