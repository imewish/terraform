resource "aws_iam_role" "codebuild_role" {
    name = "codebuild_${var.pipeline_name}"
    assume_role_policy = "${file("${path.module}/roles/codebuild.json")}"
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild_${var.pipeline_name}"
  role = "${aws_iam_role.codebuild_role.id}"
  policy = "${file("${var.codebuild_policy_json_path}")}"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_${var.pipeline_name}"
  assume_role_policy = "${file("${path.module}/roles/codepipeline.json")}"
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline${var.pipeline_name}"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = "${file("${var.codepipeline_policy_json_path}")}"
}

resource "aws_codebuild_project" "codebuild_project" {
    name = "${var.pipeline_name}"
    description = "${var.pipeline_name}"
    build_timeout = "${var.codebuild_project_build_timeout}"
    service_role = "${aws_iam_role.codebuild_role.arn}"

    artifacts {
      type = "NO_ARTIFACTS"
    }

    environment {
        compute_type                = "${var.codebuild_project_compute_type}"
        image                       = "aws/codebuild/standard:2.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"
    }    

    source {
        type    = "NO_SOURCE"
        buildspec = "${file("${var.codebuild_buildspec_path}")}"
    }

    logs_config {
        cloudwatch_logs {
            group_name = "${var.pipeline_name}"
        }
    }
    
    tags = {
        Environment = "devel"
    }
}

resource "aws_codepipeline" "codepipeline" { 
    name = "${var.pipeline_name}"
    role_arn = "${aws_iam_role.codepipeline_role.arn}"

    artifact_store {
        location = "codepipeline-us-east-1-499142858908"
        type = "S3"
    }

    stage {
        name = "Source"

        action {
            name             = "GetFromGithub"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = ["source_output"]

            configuration = {
                Owner  = "maticnetwork"
                Repo   = "${var.github_repo}"
                Branch = "${var.github_branch}"
            }
        }
    }
    stage {
        name = "BuildAndDeploy"

            action {
            name             = "BuildAndDeploy"
            category         = "Build"
            owner            = "AWS"
            provider         = "CodeBuild"
            input_artifacts  = ["source_output"]
            output_artifacts = ["build_output"]
            version          = "1"

            configuration = {
                ProjectName = "${aws_codebuild_project.codebuild_project.id}"
            }
        }
    }
}