### Creates S3 website with Cloudfront


### Usage

```
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

module "demo_website" {
  source = "module_path"
  bucket_name = "domain_name"
  domain_name = "domain_name"
  ssl_arn = "acm_certificate_arn_for_the_domain"
  env = "production"
}
```


### How to deploy

`terraform init`

`terraform plan`

`terrform deploy`