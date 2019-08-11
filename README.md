# Deploying Scalable Services with IaC

## Introduction

This repository contains code used at the [2019/08/14 event at Inclusive Tech Lab](https://www.meetup.com/Inclusive-Tech-Lab/events/263582041/) to introduce the concept of Infrastructure as Code (IaC). True to fashion, the code is versioned the same way that any other software project would be, and more so is licensed under an open-source license.

Since the code is a snapshot of what was presented at the event, contributions to this repository are not accepted - feel free to fork and continue development!

## About the event

### What will we do?
We will learn about best practices for creating and scaling born-in-the-cloud applications, using a simple blog as an example. This is not your typical "fire up an EC2 instance and install WordPress" workshop! We'll deploy WordPress, but will leverage containers and managed services within AWS, and will show how to scale the system up when it's under pressure.

### What tools and concepts will we learn about?
* **Containers** - we'll deploy WordPress from the community Docker image, with some of our own tweaks made.
* **Managed services** - we'll make AWS do the heavy lifting for our database using Amazon RDS.
* **Repeatability** - we'll use two popular tools in the Hashicorp stack, Packer and Terraform, to automate the setup of our environment.
* **Horizontal scalability** - we'll make our blog horizontally scalable in the face of load using AWS Autoscaling, Elastic Load Balancing, and Route 53.

### Agenda
1. We'll use **Terraform** to stamp out our basic AWS environment: a VPC, some subnets, and some routing rules.
2. We'll evolve our **Terraform** environment to bootstrap our RDS database.
3. We'll use **Docker** to make an image that can talk to our database, and run it locally.
4. We'll use **Packer** to deploy that image into an AMI, so that we can repeatably launch new instances from it.
5. We'll evolve our **Terraform** environment again, this time to create an autoscaling group, a load balancer, and a DNS name for our blog.
6. We'll simulate load on our blog, and scale it up in response.
7. Finally, we'll destroy our entire environment, to prevent accruing unneeded cost.

## Format of the subdirectories
Each topic is presented inside a subdirectory, and is a separately-consumable entity. Included is an example of how to run the code, a discussion on what the code does, and a discussion on what was left out (to make the demo easily consumable) that should be considered in a system that scales to hundreds or thousands of nodes.
