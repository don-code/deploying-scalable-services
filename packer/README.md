# Packer

[Packer](https://packer.io) self-describes itself as "...an open source tool for creating identical machine images for multiple platforms from a single source configuration." ([source](http://packer.io/intro/index.html#what-is-packer-)) Part of the HashiCorp stack, this demonstration will use it to preprovision Amazon Linux into a form suitable for deploying a WordPress blog in a rapid, repeatable manner.

## How Packer is used in this demo?
The `wordpress.json` Packer template utilizes the VPC created in a previous step to bootstrap inside of. From there, it executes the following steps:
1. Install the Docker container engine.
2. Configure Docker to start up at boot, so that system scripts can interact with it.
3. Download a WordPress Docker image from [Dockerhub](https://hub.docker.com/_/wordpress), so that the system can get going after boot quicker.

## How is it used?
Simply download Packer and run it against `wordpress.json`:
```
[don@localhost redshirt ~/deploying-scalable-services/packer]$ packer build wordpress.json 
amazon-ebs output will be in this color.

==> amazon-ebs: Prevalidating AMI Name: packer-wordpress 1565494033
    amazon-ebs: Found Image ID: ami-0b898040803850657
==> amazon-ebs: Creating temporary keypair: packer_5d4f8b11-bef8-46ea-40c5-2094739fb903
==> amazon-ebs: Creating temporary security group for this instance: packer_5d4f8b12-767c-4221-c6a7-127bcef78b2c
==> amazon-ebs: Authorizing access to port 22 from 0.0.0.0/0 in the temporary security group...
==> amazon-ebs: Launching a source AWS instance...
==> amazon-ebs: Adding tags to source instance
    amazon-ebs: Adding tag: "Name": "Packer Builder"
    amazon-ebs: Instance ID: i-0094f3794a7ca2ba1
==> amazon-ebs: Waiting for instance (i-0094f3794a7ca2ba1) to become ready...
==> amazon-ebs: Waiting for SSH to become available...
 
[...]

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-1: ami-057f5b1a6095ac2cd
```

Under the hood, Packer has performed the following activities:

1. Created a temporary EC2 instance, private key pair, and security group to provision with.
2. Installed and configured Docker and the WordPress Docker image.
3. Shut the instance down, taken a snapshot of it, and registered that snapshot as an Amazon Machine Image (AMI), from which clone instances can be bootstrapped.
4. Removed the instance, key pair, and security group.

## What techniques are being demonstrated?

1. **Image-based deployment.** Code is being delivered onto the image prior to deployment time.
  * This has the convenient effect of making the deployment process and the rollback process the same - terminate instances and let new ones come up.
  * A node that "goes bad" can be replaced automatically by termiating it. This will happen - Amazon will even cause it!
  * Code and config changes deploy through the same process - the deployable unit is a combination of both.
2. **Environment-agnostic builds.** Code was deployed without any environment-specific configuration - the same AMI can be used for dev, staging, and production.
  * Configuration gets provided at runtime in another layer. Builds should know nothing about where they will run.
  * This ensures that the exact same code and configuration being tested in staging gets deployed into production. No drift is possible.
3. **Version pinning.** By pinning to a particular version of WordPress, unexpected surprises - such as being upgraded to a new version that requires a manual database migration - can be avoided and planned for.
  * There is still an onus to stay up to date! WordPress is notoriously insecure. Falling behind exposes undue security risks.
  * Maybe a security risk is an acceptable tradeoff for WordPress throwing errors to the user when the database schema changes under the hood.

## What did this demo sacrifice?
1. **Configuration management.** The demo used a shell script to perform provisioning. Shell scripts, while quick and dirty, do not scale to complex systems. Tools such as [Chef](https://chef.io) exist to describe and test configuration a in repeatable, reusable manner.
2. **Container orchestration.** One container per instance is easy to implement, but leads to waste when running hundreds or thousands of conmtainers. Tools such as [Kubernetes](https://kubernetes.io/) exist to deploy multiple containers to a single instance.
