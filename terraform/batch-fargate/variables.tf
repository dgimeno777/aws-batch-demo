locals {
  local_resource_prefix = "batch-fargate"
  local_resource_suffix = terraform.workspace
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_profile" {
  type        = string
  description = "AWS Profile"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet IDs"
}

variable "batch_fargate_image" {
  description = "Image to use for AWS Batch Fargate job"
  type = object({
    ecr_repo_name         = string
    image_identifier_type = string
    image_identifier      = string
  })
}
