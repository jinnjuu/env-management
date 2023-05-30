################################################################################
# Provider
################################################################################

variable "region" {
  description = "The Default region"
  type        = string
  default     = "eu-west-1"
}

################################################################################
# VPC
################################################################################

variable "project" {
  default = "env-mgmt"
}

variable "vpc_cidr" {
  description = "VPC default CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

################################################################################
# Subnet
################################################################################

variable "public_subnets_cidr" {
  description = "Public subnet CIDR"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr_app" {
  description = "private subnet CIDR"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnets_cidr_db" {
  description = "private subnet CIDR"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

################################################################################
# ECS
################################################################################

variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  default     = "env-mgmt-cluster"
}

variable "ecs_service_name" {
  description = "The name of the ECS Service"
  default     = "env-mgmt-service"
}

variable "ecs_container_name" {
  description = "The name of the ECS container"
  default     = "env-mgmt-app"
}

variable "ecs_task_definition_family" {
  description = "CPU of the ECS "
  default     = "env-mgmt-task"
}

variable "app_port" {
  description = "Application port"
  default     = "8080"
}

variable "ecs_task_cpu" {
  description = "CPU of the ECS task "
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory of the ECS task "
  default     = 1024
}

variable "ecs_container_cpu" {
  description = "CPU of the ECS container "
  default     = 256
}

variable "ecs_container_memory" {
  description = "Memory of the ECS container "
  default     = 1024
}

################################################################################
# RDS
################################################################################

variable "rds_identifier" {
  description = "The name of the RDS instance"
  default     = "env-mgmt-db"
}

variable "rds_username" {
  description = "Default user"
  default     = "mgmt"
}

#variable "rds_password" {
#  description = "User's password. The MasterUserPassword should be longer than 8 characters."
#}

variable "rds_db_name" {
  description = "The name of the database to create when the DB instance is created."
  default     = "mydb"
}

variable "rds_instance_type" {
  description = "Default RDS instance type"
  type        = string
  default     = "db.t2.micro"
}

variable "rds_engine_type" {
  description = "Database engine"
  default     = "mariadb"
}

variable "rds_engine_version" {
  description = "Database engine version"
  default     = "10.6.10"
}

variable "rds_port" {
  description = "Database port"
  default     = "3306"
}

variable "rds_parameter_group_family" {
  description = "Database Parameter Group Family"
  default     = "mariadb10.6"
}

variable "rds_option_major_engine_version" {
  description = "Database Option Major Engine Version"
  default     = "10.6"
}

################################################################################
# ECR
################################################################################

variable "ecr_name" {
  description = "Name of the repository."
  default     = "env-mgmt-ecr"
}

################################################################################
# Cloud Watch
################################################################################

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default is 30 days"
  type        = number
  default     = 30
}