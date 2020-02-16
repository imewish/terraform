variable "bucket_name" {
  description = "The Name of S3 Bucket"
  type        = string
}

variable "domain_name" {
  description = "Cloudfront origin id"
  type        = string
}

variable "ssl_arn" {
  description = "Arn of ACM certificate"
  type        = string
}

variable "env" {
  description = "Website env"
  type        = string
}