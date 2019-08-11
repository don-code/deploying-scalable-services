module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  azs = "${var.azs}"
  cidr = "${var.cidr}"
  enable_nat_gateway = true
  map_public_ip_on_launch = false
  name = "${var.name}"
  public_subnets = "${var.public_subnet_cidrs}"
  private_subnets = "${var.private_subnet_cidrs}"
}
