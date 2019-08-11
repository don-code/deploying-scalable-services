resource "aws_security_group" "rds" {
  name   = "${var.name}-db"
  vpc_id = "${data.aws_vpc.vpc.id}"

  egress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port       = 0
    protocol        = -1
    to_port         = 0
  }

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app.id}"]
    to_port         = 3306
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  allocated_storage      = 5
  backup_window          = "03:00-06:00"
  engine                 = "mysql"
  engine_version         = "5.7.19"
  family                 = "mysql5.7"
  identifier             = "${var.name}-rds"
  instance_class         = "db.t2.micro"
  maintenance_window     = "Mon:00:00-Mon:03:00"
  major_engine_version   = "5.7"
  name                   = "wordpress"
  password               = "${var.rds_password}"
  port                   = "3306"
  subnet_ids             = "${data.aws_subnet_ids.private.ids}"
  username               = "wordpress"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
}
