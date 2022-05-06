terraform {
  backend "s3" {
    # Variables not allowed so hardcode
    key     = "aws-batch-demo/batch-fargate/terraform.tfstate"
    region  = "us-east-1"
    profile = "aws_batch_demo"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
