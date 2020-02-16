
### Terraform module to deploy static websites from github to S3 using AWS Codepipeline


### Usage

### Export Github token to grant aws codepipeline access to github repo

`export GITHUB_TOKEN="xxxxxxxxxxxxxx"`

```

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

module "demo-pipeline" {
  source = "module_path"
  pipeline_name = "demo-production"
  codebuild_buildspec_path = "configs/buildspec.yml"
  codebuild_policy_json_path = "policies/codebuild.json"
  codepipeline_policy_json_path = "policies/codepipeline.json"
  github_repo = "repo_name"
  github_branch = "branch_name"
  codepipeline_deploy_bucket = "bucket_name"
}
```

### plcae codebuild and codepipeline IAM roles to policies folder

### place buildspec.yml to config folder


### How to deploy

`terraform init`

`terraform plan`

`terrform deploy`