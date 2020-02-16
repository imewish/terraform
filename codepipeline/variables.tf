
variable "pipeline_name" {
  description = "Codepipeline name"
  type        = string
}

variable "codebuild_project_build_timeout" {
  description = "Codebuild policy name"
  type        = string
  default     = "5"
}

variable "codepipeline_policy_json_path" {
  description = "path to codepipeline IAM policy"
  type        = string
}
variable "codebuild_policy_json_path" {
  description = "path to codebuld IAM policy"
  type        = string
}

variable "codebuild_project_compute_type" {
  description = "Codebuild policy name"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_buildspec_path" {
  description = "Codebuild buildspec path"
  type        = string
}

variable "github_repo" {
  description = "Github repo to pull latest code"
  type        = string
}

variable "github_branch" {
  description = "Github branch"
  type        = string
}

variable "codepipeline_deploy_bucket" {
  description = "S3 bucket to deploy the final artrifacts"
  type        = string
}