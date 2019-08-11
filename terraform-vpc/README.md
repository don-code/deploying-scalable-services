# Terraform - VPC example

"[Terraform](https://terraform.io) enables you to safely and predictably create, change, and improve infrastructure." ([source](https://terraform.io)) Part of the HashiCorp stack, this part of the demo will use it to build out network underpinnings in AWS needed to run the demo - such as a VPC, subnets, routing tables, and so on.

## How is Terraform used to initialize the network?
The upstream [AWS VPC Terraform module](https://github.com/terraform-aws-modules/terraform-aws-vpc) is used to perform most of the configuration on the user's behalf. Upstream modules enable codification of best practices - beginners should not attempt to discover best practices the first time around, but rather should research best practices once the need arises to understand and extend them.

The module is configured to create:

1. An AWS VPC - a logically isolated set of network resources within AWS.
2. Subnets in several availability zones, enabling resources to be deployed into more than one physical data hall.
3. Route tables, to allow resources in those availability zones to talk to each other.

## How is it used?
Download Terraform 0.12 (versions matter!) and initialize in this repository, so that plugins and modules are downloaded:
```
[don@localhost prod ~/deploying-scalable-services/terraform-vpc:master]$ terraform init
Initializing modules...
Downloading terraform-aws-modules/vpc/aws 2.9.0 for vpc...
- vpc in .terraform/modules/vpc/terraform-aws-modules-terraform-aws-vpc-b51422b

Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Run `terraform plan` to get a report of resources which will be created:

```
[don@localhost redshirt ~/deploying-scalable-services/terraform-vpc:master]$ terraform12 plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.vpc.aws_route_table.private[0] will be created
  + resource "aws_route_table" "private" {
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "Name" = "production-don-test-private-us-east-1a"
        }
      + vpc_id           = (known after apply)
    }

[...]

  # module.vpc.aws_vpc.this[0] will be created
  + resource "aws_vpc" "this" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "192.168.253.0/24"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = false
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
      + tags                             = {
          + "Name" = "production-don-test"
        }
    }

Plan: 13 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

Once the plan has been reviewed and accepted, run `terraform apply` to create, update, or delete resources:
```
[don@localhost redshirt ~/deploying-scalable-services/terraform-vpc:master]$ terraform12 apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

[...]

Plan: 13 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.vpc.aws_vpc.this[0]: Creating...
module.vpc.aws_vpc.this[0]: Creation complete after 2s [id=vpc-09b9836817ef2525f]
module.vpc.aws_subnet.private[2]: Creating...
module.vpc.aws_route_table.private[1]: Creating...
module.vpc.aws_route_table.private[2]: Creating...
module.vpc.aws_route_table.private[0]: Creating...
module.vpc.aws_subnet.private[3]: Creating...
module.vpc.aws_subnet.private[1]: Creating...
module.vpc.aws_route_table.private[3]: Creating...
module.vpc.aws_subnet.private[0]: Creating...
module.vpc.aws_route_table.private[2]: Creation complete after 1s [id=rtb-0c63f5dc95d2b0d2a]
module.vpc.aws_route_table.private[1]: Creation complete after 1s [id=rtb-07ddf4c8dd6fb0257]
module.vpc.aws_route_table.private[0]: Creation complete after 1s [id=rtb-0fab03c56fbf47d3a]
module.vpc.aws_route_table.private[3]: Creation complete after 1s [id=rtb-00cc2653834742c8f]
module.vpc.aws_subnet.private[2]: Creation complete after 1s [id=subnet-0b1b7acafafbdcf97]
module.vpc.aws_subnet.private[1]: Creation complete after 1s [id=subnet-08475c38f0ef2ad61]
module.vpc.aws_subnet.private[0]: Creation complete after 1s [id=subnet-06ad9c52fd940bc44]
module.vpc.aws_subnet.private[3]: Creation complete after 1s [id=subnet-07abb6bd07d41c79f]
module.vpc.aws_route_table_association.private[1]: Creating...
module.vpc.aws_route_table_association.private[3]: Creating...
module.vpc.aws_route_table_association.private[2]: Creating...
module.vpc.aws_route_table_association.private[0]: Creating...
module.vpc.aws_route_table_association.private[3]: Creation complete after 1s [id=rtbassoc-0451531602d72ca60]
module.vpc.aws_route_table_association.private[1]: Creation complete after 1s [id=rtbassoc-04b2bdcad6f5fa8c8]
module.vpc.aws_route_table_association.private[2]: Creation complete after 1s [id=rtbassoc-0f714996fb3a674e0]
module.vpc.aws_route_table_association.private[0]: Creation complete after 1s [id=rtbassoc-0ab40515b980ffbc9]

Apply complete! Resources: 13 added, 0 changed, 0 destroyed.
```

## What techniques are being demonstrated?

1. **Core infrastructure as code.** The lowest levels of infrastructure here are reflected in source.
  * Changes to the infrastructure can be reviewed and versioned, just like any other code.
  * Tests can run against the code.
  * In five years, it is possible to use `git log` and `git blame` to determine why a certain change was made, even after key contributors have turned over.
2. **Upstream modules.** Rather than reinvent the wheel, use of an open-source module for creating a VPC and related resources enables us to spend less time learning key lessons.
  * The module contributor has already learned the lessons the hard way.
  * The module consumer can determine how the module works, and how to extend it, should the time ever come.
3. **Environment-specific data as variables.** The same Terraform code can be used with multiple [workspaces](https://www.terraform.io/docs/state/workspaces.html) to ensure that staging, production, and any other environments are configured in the same manner.

## What did this demo sacrifice?
1. **Remote state.** This Terraform repository maintains a local state - meaning that individual developers maintain individual states on their workstations. Terraform supports working with [remote states](https://www.terraform.io/docs/state/remote.html) so that all developers share state, and can lock the state to prevent others from modifying it at the same time.
2. **Automated runs.** Running Terraform manually does not scale - many will want to run it at the same time; `plan` and `apply` runs can fall out of sync. Fronting Terraform with a CI tool such as [Jenkins](https://jenkins.io) can alleviate these issues.
3. **Secure ingress.** Setting up a VPN gateway is foregone; all communications betweeen instances and users goes directly over the public Internet. AWS has [several managed options for VPN-based ingress](https://docs.aws.amazon.com/vpc/latest/userguide/vpn-connections.html); tools such as [pritunl](https://pritunl.com/) also exist to do the same.
