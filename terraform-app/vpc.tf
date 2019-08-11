data "aws_vpc" "vpc" {
  tags = {
    "Name" = "${var.name}"
  }
}

data "aws_subnet_ids" "public" {
  filter {
    name = "tag:Name"
    values = ["${var.name}-public*"]
  }
  vpc_id = "${data.aws_vpc.vpc.id}"
}

data "aws_subnet_ids" "private" {
  filter {
    name = "tag:Name"
    values = ["${var.name}-private*"]
  }
  vpc_id = "${data.aws_vpc.vpc.id}"
}
