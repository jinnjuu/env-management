output "ecr_repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "lb_dns_name" {
  value =  aws_lb.alb.dns_name
}