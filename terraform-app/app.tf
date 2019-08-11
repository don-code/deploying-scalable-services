data "aws_ami" "wordpress" {
  filter {
    name   = "name"
    values = ["packer-wordpress *"]
  }

  most_recent = true
  owners      = ["self"]
}

resource "aws_security_group" "app" {
  name   = "${var.name}-app"
  vpc_id = "${data.aws_vpc.vpc.id}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = -1
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    from_port       = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
    to_port         = 80
  }
}

data "template_file" "user_data" {
  template = "${file("user_data.sh.tpl")}"

  vars = {
    wordpress_db_host     = "${module.rds.this_db_instance_address}"
    wordpress_db_name     = "${module.rds.this_db_instance_name}"
    wordpress_db_password = "${module.rds.this_db_instance_password}"
    wordpress_db_user     = "${module.rds.this_db_instance_username}"
  }
}

module "app" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  associate_public_ip_address = true
  desired_capacity            = 1
  health_check_type           = "EC2"
  image_id                    = "${data.aws_ami.wordpress.id}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_pair_name}"
  load_balancers              = ["${module.elb.this_elb_id}"]
  max_size                    = 2
  min_size                    = 0
  name                        = "${var.name}-app"
  security_groups             = ["${aws_security_group.app.id}"]
  user_data                   = "${data.template_file.user_data.rendered}"
  vpc_zone_identifier         = "${data.aws_subnet_ids.public.ids}"
}
