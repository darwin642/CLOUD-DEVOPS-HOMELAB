# AWS Terraform Implementation

## Overview

This page documents the Terraform implementation used to provision and manage the AWS infrastructure in the lab environment.

The configuration covers networking, security, EC2 instances, application load balancing, IAM, monitoring, Systems Manager connectivity, and S3 lifecycle management.

Terraform is used to define these resources as code instead of configuring them manually through the AWS Management Console.

---

# 1. Provider Configuration and Variables

The AWS provider defines how Terraform communicates with AWS.

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

### Code Explanation

* `terraform {}` defines Terraform-level configuration.
* `required_providers` tells Terraform which providers are required.
* `aws` identifies the AWS provider.
* `source = "hashicorp/aws"` specifies the official AWS provider.
* `provider "aws"` configures the AWS provider itself.
* `region = var.aws_region` tells Terraform which AWS region to use.
* The region is referenced through a variable instead of being hardcoded directly into the provider.

This allows the same Terraform configuration to be reused in another AWS region by changing the variable value.

---

## Variables

The environment-specific configuration is separated from the resource definitions.

```hcl
variable "aws_region" {
  description = "AWS region for the lab"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "private_cidr" {
  description = "CIDR block for private subnet"
  type        = string
}
```

### Code Explanation

Each `variable` block creates an input that can be reused throughout the Terraform configuration.

For example:

```hcl
vpc_cidr = var.vpc_cidr
```

means that the VPC does not contain a hardcoded CIDR address. Terraform retrieves the value from the `vpc_cidr` variable.

This makes the infrastructure easier to reuse between different environments.

---

# 2. Local Values and Common Tags

Local values are used for configuration values that are referenced multiple times.

```hcl
locals {
  project     = "aws-lab"
  environment = "dev"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}
```

### Code Explanation

* `locals` creates values that are calculated or defined once and reused throughout the configuration.
* `local.project` stores the project name.
* `local.environment` identifies the environment.
* `common_tags` creates a reusable set of AWS tags.
* `local.project` references the previously defined project value.
* `local.environment` references the environment value.

Resources can then use:

```hcl
tags = local.common_tags
```

Instead of manually defining the same tags on every AWS resource.

This provides consistent resource identification and makes it clear that the infrastructure is managed by Terraform.

---

# 3. VPC and Network

The main VPC provides the isolated network boundary for the entire AWS environment.

```hcl
resource "aws_vpc" "benbenim" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.common_tags
}
```

### Code Explanation

* `resource "aws_vpc"` tells Terraform to create an AWS VPC.
* `"benbenim"` is Terraform's local resource name.
* `cidr_block = var.vpc_cidr` assigns the VPC address space from the variable.
* `enable_dns_support = true` enables DNS resolution inside the VPC.
* `enable_dns_hostnames = true` allows instances in the VPC to receive DNS hostnames.
* `tags = local.common_tags` applies the common project and environment tags.

The resource can then be referenced elsewhere using:

```hcl
aws_vpc.benbenim.id
```

Terraform automatically understands that other resources depending on this value must use the VPC created by this resource.

---

# 4. Subnet Architecture

The environment contains three subnets:

| Subnet   | CIDR          | Availability Zone | Purpose |
| -------- | ------------- | ----------------- | ------- |
| Public 1 | `10.0.1.0/24` | `eu-north-1a`     | WEB01   |
| Public 2 | `10.0.2.0/24` | `eu-north-1b`     | WEB02   |
| Private  | `10.0.3.0/24` | `eu-north-1a`     | APP01   |

The two web servers are distributed across separate Availability Zones.

```hcl
resource "aws_subnet" "public1_subnet" {
  vpc_id            = aws_vpc.benbenim.id
  cidr_block        = var.public1_cidr
  availability_zone = "eu-north-1a"
  tags              = local.common_tags
}

resource "aws_subnet" "public2_subnet" {
  vpc_id            = aws_vpc.benbenim.id
  cidr_block        = var.public2_cidr
  availability_zone = "eu-north-1b"
  tags              = local.common_tags
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.benbenim.id
  cidr_block        = var.private_cidr
  availability_zone = "eu-north-1a"
  tags              = local.common_tags
}
```

### Code Explanation

Each `aws_subnet` resource creates a subnet inside the VPC.

For example:

```hcl
vpc_id = aws_vpc.benbenim.id
```

connects the subnet to the VPC created earlier.

```hcl
cidr_block = var.public1_cidr
```

assigns the subnet's IP address range.

```hcl
availability_zone = "eu-north-1a"
```

places the subnet into a specific Availability Zone.

The important architectural difference is that `WEB01` and `WEB02` are placed into different Availability Zones.

This provides Availability Zone-level redundancy for the web tier.

---

# 5. Internet Gateway

The Internet Gateway provides a path between the VPC and the public internet.

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.benbenim.id

  tags = local.common_tags
}
```

### Code Explanation

* `aws_internet_gateway` creates an Internet Gateway.
* `vpc_id` attaches it to the lab VPC.
* `tags` applies the common resource tags.

Creating the Internet Gateway alone does not automatically make a subnet public.

A route must also exist that sends internet-bound traffic to the gateway.

---

# 6. Route Tables and Routing

The public route table contains a default route to the Internet Gateway.

```hcl
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
```

### Code Explanation

* `route_table_id` identifies the route table receiving the route.
* `destination_cidr_block = "0.0.0.0/0"` represents all IPv4 destinations.
* `gateway_id` specifies the Internet Gateway used as the next hop.

Therefore, traffic matching `0.0.0.0/0` is sent toward the Internet Gateway.

The resulting network path is:

```text
WEB01 / WEB02
      │
      ▼
Public Route Table
      │
      ▼
Internet Gateway
      │
      ▼
   Internet
```

---

# 7. Security Groups

Security Groups are used to control traffic between the different application layers.

The architecture uses separate Security Groups for:

* Application Load Balancer
* Web servers
* Application server

---

## ALB Security Group

```hcl
ingress {
  description = "HTTP from Internet"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

### Code Explanation

This rule allows HTTP traffic to reach the Application Load Balancer.

* `from_port = 80` defines the starting port.
* `to_port = 80` defines the ending port.
* `protocol = "tcp"` limits the rule to TCP traffic.
* `0.0.0.0/0` allows HTTP requests from any IPv4 source.

The ALB is therefore the public entry point for HTTP traffic.

---

## Web Security Group

```hcl
ingress {
  description     = "HTTP from ALB"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  security_groups = [aws_security_group.alb.id]
}
```

### Code Explanation

Unlike the ALB rule, the web servers do not accept HTTP traffic from the entire internet.

Instead:

```hcl
security_groups = [aws_security_group.alb.id]
```

allows HTTP traffic only when the source belongs to the ALB Security Group.

The traffic flow therefore becomes:

```text
Internet
   │
   ▼
ALB Security Group
   │
   ▼
Web Security Group
   │
   ▼
WEB01 / WEB02
```

This prevents users from directly accessing the web servers through their public interfaces while still allowing the ALB to reach them.

---

## Application Security Group

The application server is placed in the private subnet and only accepts traffic from the web tier.

```hcl
ingress {
  description     = "HTTP from Web Servers"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  security_groups = [aws_security_group.web.id]
}
```

### Code Explanation

The important part is:

```hcl
security_groups = [aws_security_group.web.id]
```

The rule does not allow HTTP traffic from the internet.

Only resources associated with the web Security Group are allowed to reach the application server on port `80`.

This creates a layered security model:

```text
Internet
   │
   ▼
   ALB
   │
   │ HTTP :80
   ▼
 WEB01 / WEB02
   │
   │ HTTP :80 / :8080
   ▼
 APP01
```

---

# 8. EC2 Instances

The EC2 resources provide the compute layer.

```hcl
resource "aws_instance" "web01" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public1_subnet.id

  security_groups = [
    aws_security_group.web.id
  ]
}
```

### Code Explanation

* `aws_instance` creates an EC2 instance.
* `ami` defines the operating system image.
* `instance_type` defines the compute capacity.
* `subnet_id` determines which subnet contains the instance.
* `security_groups` associates the instance with the web Security Group.

The same concept is used for `WEB02`, but `WEB02` is placed into the second public subnet and therefore another Availability Zone.

`APP01` is placed into the private subnet and does not require a public IP.

---

# 9. Application Load Balancer

The Application Load Balancer distributes incoming HTTP traffic between the two web servers.

```hcl
resource "aws_lb" "main" {
  name               = "aws-lab-alb"
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public1_subnet.id,
    aws_subnet.public2_subnet.id
  ]

  security_groups = [
    aws_security_group.alb.id
  ]
}
```

### Code Explanation

* `aws_lb` creates the Load Balancer.
* `load_balancer_type = "application"` creates an Application Load Balancer.
* The two subnet IDs place the ALB across both Availability Zones.
* The ALB Security Group controls incoming traffic.

The ALB then forwards requests to its target group.

```text
                 Internet
                    │
                    ▼
             Application LB
              /          \
             /            \
          WEB01          WEB02
           AZ-a           AZ-b
```

---

# 10. Target Group

The target group defines which backend instances receive traffic from the ALB.

```hcl
resource "aws_lb_target_group" "web" {
  name     = "aws-lab-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.benbenim.id
}
```

### Code Explanation

* `port = 80` defines the backend destination port.
* `protocol = "HTTP"` tells the ALB how to communicate with the targets.
* `vpc_id` associates the target group with the lab VPC.

WEB01 and WEB02 are then registered as targets.

The ALB receives the request and forwards it to one of the healthy targets.

---

# 11. Web-to-Application Communication

The web servers act as reverse proxies for the private application server.

The application traffic follows:

```text
Client
  │
  │ HTTP :80
  ▼
ALB
  │
  ▼
WEB01 / WEB02
  │
  │ HTTP :80 / :8080
  ▼
APP01
```

### Code Concept

The Terraform configuration establishes the network and Security Group permissions required for this communication.

The actual reverse-proxy configuration runs on the web servers and forwards requests to the private IP address of `APP01`.

This keeps `APP01` private while still allowing the web tier to consume its application service.

---

# 12. IAM

IAM resources define identities and permissions for AWS access.

```hcl
resource "aws_iam_user" "lab_user" {
  name = "lab-user"
}
```

### Code Explanation

* `aws_iam_user` creates an IAM user.
* The `name` attribute defines the user's AWS identity.

Permissions can then be attached separately.

This allows identity creation and authorization to be managed as code instead of manually configuring users through the AWS Console.

---

# 13. CloudWatch Monitoring

CloudWatch alarms are used to monitor infrastructure metrics.

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
}
```

### Code Explanation

* `aws_cloudwatch_metric_alarm` creates a CloudWatch alarm.
* `alarm_name` gives the alarm a recognizable name.
* `comparison_operator` defines how the metric is evaluated.
* `threshold = 80` defines the configured limit.

When the monitored metric crosses the configured threshold, CloudWatch changes the alarm state.

---

# 14. Systems Manager Connectivity

AWS Systems Manager can provide administrative access to EC2 instances without requiring inbound SSH access from the internet.

The architecture uses Systems Manager-related infrastructure to allow private resources to communicate with AWS management services.

```text
APP01
  │
  │ HTTPS :443
  ▼
VPC Endpoints
  │
  ├── SSM
  ├── SSMMessages
  └── EC2Messages
  │
  ▼
AWS Systems Manager
```

### Code Concept

The important Terraform components are the VPC endpoints and their associated Security Group.

The endpoints provide private connectivity from the VPC to AWS Systems Manager services.

This allows `APP01` to remain private without requiring a public IP address or an internet-facing SSH service.

---

# 15. S3 Lifecycle Management

S3 lifecycle configuration can automatically transition or expire objects based on defined rules.

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "lab" {
  bucket = aws_s3_bucket.lab.id

  rule {
    id     = "cleanup"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}
```

### Code Explanation

* `aws_s3_bucket_lifecycle_configuration` defines lifecycle behavior for the bucket.
* `bucket` identifies which S3 bucket the rule applies to.
* `rule` creates a lifecycle rule.
* `status = "Enabled"` activates the rule.
* `expiration` defines when objects should expire.
* `days = 30` means matching objects are automatically deleted after 30 days.

This allows storage management to be automated instead of manually cleaning up objects.

---

# 16. Terraform State

Terraform maintains a state file to keep track of the infrastructure it manages.

```text
Terraform Configuration
        │
        ▼
   terraform plan
        │
        ▼
Terraform State
        │
        ▼
  AWS Infrastructure
```

The state allows Terraform to determine which resources already exist and what changes are required.

The state file is intentionally excluded from the public documentation because it can contain sensitive infrastructure information.

---

# 17. Terraform Workflow

The infrastructure is managed using the standard Terraform workflow.

```bash
terraform init
terraform plan
terraform apply
```

### `terraform init`

Initializes the Terraform working directory and downloads the required AWS provider.

### `terraform plan`

Compares the Terraform configuration with the current Terraform state and AWS infrastructure.

It shows what Terraform would create, modify or destroy before any changes are made.

### `terraform apply`

Applies the planned configuration to AWS.

After the infrastructure was represented in Terraform, the configuration was validated using:

```bash
terraform plan
```

A successful:

```text
No changes
```

result means that the Terraform configuration matches the infrastructure currently represented in the Terraform state.

---

# 18. Infrastructure as Code Model

The complete Terraform architecture follows a declarative model:

```text
Terraform Code
      │
      ▼
Terraform Provider
      │
      ▼
AWS API
      │
      ▼
AWS Infrastructure
```

Instead of manually creating each resource through the AWS Console, the desired infrastructure is described in HCL.

Terraform then determines the required actions to make the real AWS environment match the declared configuration.

This provides:

* Repeatable deployments
* Version-controlled infrastructure
* Consistent configuration
* Easier infrastructure changes
* Reduced manual configuration
* Infrastructure drift detection
* Reproducible environments
