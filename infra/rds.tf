module "rds" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = var.rds_identifier

  engine            = var.rds_engine_type
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_instance_type
  allocated_storage = 5
  storage_encrypted = false

  db_name  = var.rds_db_name
  username = var.rds_username
#  password = var.rds_password
  port     = var.rds_port

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [aws_security_group.db.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval = "30"
  monitoring_role_name = "RDSMonitoringRole-${var.project}"
  create_monitoring_role = true

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = aws_subnet.private_subnet_db[*].id

  # DB parameter group
  family = var.rds_parameter_group_family

  # DB option group
  major_engine_version = var.rds_option_major_engine_version

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    },
    {
      name = "character_set_connection"
      value = "utf8mb4"
    },
    {
      name = "character_set_database"
      value = "utf8mb4"
    },
    {
      name = "character_set_filesystem"
      value = "utf8mb4"
    },
    {
      name = "character_set_results"
      value = "utf8mb4"
    },
    {
      name = "collation_connection"
      value = "utf8mb4_general_ci"
    },
    {
      name = "collation_server"
      value = "utf8mb4_general_ci"
    },
    {
      name = "log_bin_trust_function_creators"
      value = 1
    }
  ]
}
