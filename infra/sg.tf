################################################################################
# alb
################################################################################

resource "aws_security_group" "alb" {
  name        = "${var.project}-alb-sg"
  description = "Security Group for ${var.project} alb"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "alb_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id

}

################################################################################
# app
################################################################################

resource "aws_security_group" "app" {
  name        = "${var.project}-app-sg"
  description = "Security Group for ${var.project} app"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "app_http_ingress" {
  type              = "ingress"
  from_port         = var.app_port
  to_port           = var.app_port
  protocol          = "tcp"
  security_group_id = aws_security_group.app.id
  source_security_group_id = aws_security_group.alb.id
  description = aws_security_group.alb.name
}

resource "aws_security_group_rule" "app_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app.id
}

################################################################################
# db
################################################################################

resource "aws_security_group" "db" {
  name        = "${var.project}-db-sg"
  description = "Security Group for ${var.project} db"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "db_from_app_ingress" {
  type              = "ingress"
  from_port         = var.rds_port
  to_port           = var.rds_port
  protocol          = "tcp"
  security_group_id = aws_security_group.db.id
  source_security_group_id = aws_security_group.app.id
  description = aws_security_group.app.name
}

resource "aws_security_group_rule" "db_allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}