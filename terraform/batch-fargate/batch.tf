resource "aws_iam_role" "batch_ce" {
  name = "${local.local_resource_prefix}-ce-${local.local_resource_suffix}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "batch.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "batch_ce" {
  role       = aws_iam_role.batch_ce.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_security_group" "batch_ce" {
  name   = "${local.local_resource_prefix}-ce-${local.local_resource_suffix}"
  vpc_id = data.aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_batch_compute_environment" "batch" {
  depends_on               = [aws_iam_role_policy_attachment.batch_ce]
  compute_environment_name = "${local.local_resource_prefix}-${local.local_resource_suffix}"
  type                     = "MANAGED"
  service_role             = aws_iam_role.batch_ce.arn

  compute_resources {
    type      = "FARGATE"
    max_vcpus = 16
    security_group_ids = [
      aws_security_group.batch_ce.id
    ]
    subnets = [
      for subnet in data.aws_subnet.subnets : subnet.id
    ]
  }
}

resource "aws_batch_job_queue" "batch" {
  name     = "${local.local_resource_prefix}-ce-${local.local_resource_suffix}"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.batch.arn
  ]
}

resource "aws_iam_role" "batch_wait_service_task_execution" {
  name = "${local.local_resource_prefix}-wait-service-te-${local.local_resource_suffix}"
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        "Action" : "sts:AssumeRole"
        "Effect" : "Allow"
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "batch_wait_service_task_execution" {
  role       = aws_iam_role.batch_wait_service_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_batch_job_definition" "batch_wait_service" {
  name                  = "${local.local_resource_prefix}-wait-service-${local.local_resource_suffix}"
  type                  = "container"
  platform_capabilities = ["FARGATE"]

  container_properties = jsonencode({
    image            = local.batch_fargate_image_uri
    executionRoleArn = aws_iam_role.batch_wait_service_task_execution.arn
    command          = ["poetry", "run", "python", "-m", "wait"]

    fargate_platform_configuration = {
      platformVersion = "1.4.0"
    }
    networkConfiguration = {
      assignPublicIp = "ENABLED"
    }
    resourceRequirements = [
      {
        type  = "VCPU",
        value = "0.25"
      },
      {
        type  = "MEMORY",
        value = "512"
      }
    ]
  })
}
