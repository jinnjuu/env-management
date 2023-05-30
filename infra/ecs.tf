resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  depends_on      = [aws_iam_role.ecs_execution_role]

  network_configuration {
    subnets          = aws_subnet.private_subnet_app[*].id
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.ecs_container_name
    container_port   = var.app_port
  }

  lifecycle {
    ignore_changes   = [desired_count]
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.ecs_task_definition_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${var.ecs_container_name}",
    "image": "${aws_ecr_repository.ecr.repository_url}:latest",
    "cpu": ${var.ecs_container_cpu},
    "memory": ${var.ecs_container_memory},
    "essential": true,
    "environment": [
      {
        "name": "SPRING_DATASOURCE_URL",
        "value": "jdbc:${var.rds_engine_type}://${module.rds.db_instance_address}:${var.rds_port}/${var.rds_db_name}"
      },
      {
        "name": "SPRING_DATASOURCE_USERNAME",
        "value": "${var.rds_username}"
      },
      {
        "name": "SPRING_DATASOURCE_PASSWORD",
        "value": "${module.rds.db_instance_password}"
      }
    ],
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port},
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "/ecs/${var.ecs_cluster_name}/${var.ecs_service_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "awslogs-ecs"
        }
    }
  }
]
TASK_DEFINITION

  task_role_arn             = aws_iam_role.ecs_task_role.arn
  execution_role_arn        = aws_iam_role.ecs_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_execution_custom_role" {
  name        = "ecs_execution_custom_role"
  description = "Role to allow ECS execution"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:DescribeLogStreams",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_execution_custom_role_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_custom_role.arn
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
