# Terraform - Application example.

This section builds on the Terraform code written in the previous demonstration to initialize the network. It demonstrates more advanced concepts, such as dependencies and runtime variables, as well as gives a taste of scalable services and managed services within AWS.

## What is Terraform doing?
The upstream [AWS Autoscaling Terraform module](https://github.com/terraform-aws-modules/terraform-aws-autoscaling), [AWS Elastic Load Balancer Terraform module](https://github.com/terraform-aws-modules/terraform-aws-elb), and [AWS RDS Terraform module](https://github.com/terraform-aws-modules/terraform-aws-rds) are used to initialize resources within AWS that will host the application - in this case, a WordPress blog.

[AWS Autoscaling](https://aws.amazon.com/autoscaling/) enables rapid changes in horizontal scale of a service, without needing to rerun Terraform to create or destroy instances directly. Autoscaling takes in an AMI (produced in the Packer step) and user data (to be executed on boot), and launches any number of workable EC2 instances from them. Here, the number of instances to run is hard-coded. In a more typical system, the number would be controlled by metrics.

[AWS Elastic Load Balancing](https://aws.amazon.com/elasticloadbalancing/) provides a single endpoint that will assign incoming traffic to the instances in the auto scaling group. ELBs provide features such as health checking, so that traffic is not routed to non-working nodes, as well as automatic registration and deregistration of nodes in the auto scaling group as they come up and down.

The [AWS Relational Database Service](https://aws.amazon.com/rds/) enables a hosted database to be quickly stood up, with best practices for monitoring and management baked in. Unlike EC2, which provides the VM as the primary interface, RDS provides MySQL itself as the primary interface - there is no need, and indeed no possibility, to access the VM underneath it. RDS provides automatic upgrades, database backups, read replicas, and so on as features.

The resources being created are:

1. Security groups. These are akin to firewall rules, and dictate which services are allowed to ingress and egress to which other services, or the public Internet.
2. An auto scaling launch configuration. This defines how to launch new instances of WordPress.
3. An auto scaling group. This defines how many instances to scale up, when to scale them up, and where to scale them up.
4. An RDS database. By externalizing the database into a managed service, the instances themselves can be managed statelessly.
5. An elastic load balancer. This is used to control ingress to the instances serving WordPress in a safe and predictale manner.

Under the hood, Terraform determines the appropriate order in which to create these resources, as they are interdependent - security groups must exist before a load balancer or auto scaling group can be deployed into them; an RDS instance must exist before the auto scaling group can refert to it, and so on.

The database password is sensitive data. To prevent it from being stored in the repository, it must be manually entered each time the Terraform project is run.

## How is it used?

The process is the same as that for the previous Terraform demo:
```
terraform init
terraform plan
terraform apply
```

This time around, Terraform will prompt for credentials each time it is run, e.g.:

```
[don@localhost redshirt ~/deploying-scalable-services/terraform-app:master]$ terraform12 apply
var.key_pair_name
  Enter a value: dons-key-pair

var.rds_password
  Enter a value: dons-password
```

## What techniques are being demonstrated?

1. **Principle of least access.** Security groups are configured in such a way that applications deployed into them have the minimum necessary access - databases can not egress to the Internet; only the load balancer can speak HTTP directly to the instances. This reduces attack surface in the event of a breach.
2. **Use of managed services.** RDS provides a scalable database with nearly no work on our part.
3. **Service discovery.** The outputs of one module are used as the inputs to another module. Terraform is "gluing" services together by making them aware of each other.

## What did this demo sacrifice?

1. **Secrets management.** The password must be entered at runtime each time Terraform is run. Tools such as [HashiCorp Vault](https://www.vaultproject.io/) exist to centralize secrets management.
2. **Better service discovery.** Terraform is one option for performing service discovery, but much like using DNS for service discovery, this is simplistic. [HashiCorp Consul](https://www.consul.io/) is an example of a tool that can perform real-time service discovery.
3. **Automated auto scaling.** Terraform hard-codes the number of EC2 instances to run in the auto scaling group. Tools such as [AWS CloudWatch](https://aws.amazon.com/cloudwatch/) can drive this number automatically based on metrics such as CPU load, within min and max set bounds.
4. **DRY principle.** The version of the Docker image to run is repeated in both Packer and Terraform. This could be replaced with a shell script.
