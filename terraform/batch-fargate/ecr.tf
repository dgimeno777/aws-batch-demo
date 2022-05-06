data "aws_ecr_repository" "batch_fargate" {
  name = var.batch_fargate_image.ecr_repo_name
}

data "aws_ecr_image" "batch_fargate" {
  repository_name = data.aws_ecr_repository.batch_fargate.name
  image_tag       = var.batch_fargate_image.image_identifier_type == "TAG" ? var.batch_fargate_image.image_identifier : null
  image_digest    = var.batch_fargate_image.image_identifier_type == "SHA" ? var.batch_fargate_image.image_identifier : null
}

locals {
  batch_fargate_image_uri = "${data.aws_ecr_repository.batch_fargate.repository_url}@${data.aws_ecr_image.batch_fargate.id}"
}
