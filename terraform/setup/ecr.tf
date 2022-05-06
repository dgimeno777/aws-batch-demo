resource "aws_ecr_repository" "wait_service" {
  name                 = "api-batch-demo/wait-service-${terraform.workspace}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
}
