provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

# Create S3 Bucket with website enabled
resource "aws_s3_bucket" "s3_website" {
  bucket = "${var.bucket_name}"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# Create CF Origin Access Identity for the bucket
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.domain_name}"
}

# Cretae IAM policy for the bucket
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_website.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# Update Bucket Policy 
resource "aws_s3_bucket_policy" "s3_website" {
  bucket = "${aws_s3_bucket.s3_website.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

# Create CF distribution
resource "aws_cloudfront_distribution" "s3_website" {
  origin {
    domain_name = "${aws_s3_bucket.s3_website.website_endpoint}"
    origin_id   = "${var.domain_name}"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    # s3_origin_config {
    #   origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    # }
  }

  enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.domain_name}"]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none" 
      }
    }

    target_origin_id = "${var.domain_name}"

    // This redirects any HTTP request to HTTPS. Security first!
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.ssl_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
 
  tags = {
    Environment = "${var.env}"
  }
}

