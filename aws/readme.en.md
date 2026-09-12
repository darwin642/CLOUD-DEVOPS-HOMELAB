# ☁️ Amazon Web Services Infrastructure Lab

A practical AWS infrastructure laboratory created to develop hands-on skills in cloud infrastructure, networking, security, load balancing, identity, monitoring, backup, and Infrastructure as Code.

The main goal of this laboratory is to build, configure, test, and troubleshoot a realistic AWS infrastructure environment.

---

## 📌 Project Overview

This laboratory covers the design and management of a small-scale AWS infrastructure environment using a Multi-AZ architecture.

The project covers the following areas:

* Amazon VPC
* Public and private subnets
* Internet Gateway
* Route Tables
* EC2
* Security Groups
* Application Load Balancer
* IAM
* CloudWatch
* AWS Backup
* Multi-AZ architecture
* Terraform
* Network troubleshooting

---

## 🏗️ Architecture

### Architecture Diagram

![VPC](aws_diagram.png)

The environment consists of a VPC with public and private subnets, two web servers, a private application server, and a public-facing Application Load Balancer.

WEB01 and WEB02 are deployed across different Availability Zones and handle web traffic through the Application Load Balancer.

APP01 is deployed inside a private subnet and does not have a public IP address.

---

## 1. 🌐 VPC & Subnets

The AWS networking infrastructure was created using a dedicated VPC with a public and private subnet architecture.

### Configuration

| Resource         | Configuration    |
| ---------------- | ---------------- |
| Region           | `eu-north-1`     |
| VPC              | `AWS-LAB-VPC`    |
| CIDR             | `10.0.0.0/16`    |
| Public Subnets   | `WEB01`, `WEB02` |
| Private Subnet   | `APP01`          |
| Internet Gateway | `AWS-LAB-IGW`    |

WEB01 and WEB02 are located in public subnets, while APP01 is located inside a private subnet.

WEB02 is deployed in a different Availability Zone to demonstrate a Multi-AZ architecture.

### 📸 Screenshot 01 — VPC

![VPC](01-vpc.png)

### 📸 Screenshot 02 — Subnets

![Subnets](02-subnets.png)

### 📸 Screenshot 03 — Route Tables

![Route Tables](03-route-tables.png)

### 📸 Screenshot 04 — Internet Gateway

![Internet Gateway](04-internet-gateway.png)

---

## 2. 🖥️ EC2 Infrastructure

EC2 instances were created to represent the web and application layers of the AWS environment.

### Configuration

| Server  | Role               | Network        |
| ------- | ------------------ | -------------- |
| `WEB01` | Web Server         | Public Subnet  |
| `WEB02` | Web Server         | Public Subnet  |
| `APP01` | Application Server | Private Subnet |

WEB01 and WEB02 represent the public-facing web tier, while APP01 represents the private application tier.

### 📸 Screenshot 05 — WEB01

![WEB01](05-web01.png)

### 📸 Screenshot 06 — WEB02

![WEB02](06-web02.png)

### 📸 Screenshot 07 — APP01

![APP01](07-app01.png)

---

## 3. 🔐 Security Groups

Network access to the EC2 instances is controlled using Security Groups.

Separate security policies were configured for the web and application servers.

### Configuration

* `WEB01-SG`
* `APP01-SG`
* Required network access for the web servers
* APP01 running inside the private network
* Traffic controlled through Security Group rules

APP01 does not have a public IP address.

### 📸 Screenshot 08 — WEB01 Security Group

![WEB01 Security Group](08-web01-sg.png)

### 📸 Screenshot 09 — APP01 Security Group

![APP01 Security Group](09-app01-sg.png)

---

## 4. ⚖️ Application Load Balancer

An Application Load Balancer was configured to demonstrate load balancing and high availability across the web tier.

The ALB uses WEB01 and WEB02 as its targets.

Traffic is distributed between web servers located in different Availability Zones.

### Configuration

| Resource           | Configuration             |
| ------------------ | ------------------------- |
| Load Balancer      | Application Load Balancer |
| Targets            | `WEB01`, `WEB02`          |
| Availability Zones | Multi-AZ                  |
| Backend            | EC2 Web Servers           |

### 📸 Screenshot 10 — Application Load Balancer

![Application Load Balancer](10-load-balancer.png)

### 📸 Screenshot 11 — Target Group

![Target Group](11-target-group.png)

---

## 5. 🆔 IAM

AWS Identity and Access Management was used to control access to AWS resources.

IAM users and permissions were configured to demonstrate identity and access management.

### Topics Covered

* IAM Users
* IAM Permissions
* Access control
* Least privilege approach

### 📸 Screenshot 12 — IAM Users

![IAM Users](12-iam-users.png)

### 📸 Screenshot 13 — IAM Permissions

![IAM Permissions](13-iam-permissions.png)

---

## 6. 📊 Monitoring & CloudWatch

Amazon CloudWatch was used to monitor the AWS infrastructure.

EC2 metrics were monitored and an alarm was configured based on a selected metric.

### Topics Covered

* CloudWatch Metrics
* Monitoring
* Metric Alarms
* Infrastructure monitoring

### 📸 Screenshot 14 — CloudWatch Metric

![CloudWatch Metric](14-cloudwatch-metric.png)

### 📸 Screenshot 15 — CloudWatch Alarm

![CloudWatch Alarm](15-cloudwatch-alarm.png)

---

## 7. 💾 AWS Backup

AWS Backup was used to demonstrate centralized backup management for AWS resources.

A Backup Plan was created and backup configuration was applied to the relevant resource.

### Topics Covered

* Backup Plan
* Backup configuration
* Resource assignment
* Backup management

### 📸 Screenshot 16 — Backup Plan

![Backup Plan](16-backup-plan.png)

### 📸 Screenshot 17 — Backup Resource

![Backup Resource](17-backup-resource.png)

---

## 8. 🧪 Testing & Troubleshooting

The AWS environment was tested through realistic networking and infrastructure troubleshooting scenarios.

Tests included:

* VPC network connectivity
* Public subnet connectivity
* Private subnet connectivity
* WEB01 → APP01 connectivity
* WEB02 → APP01 connectivity
* Security Group validation
* Route Table validation
* Internet Gateway connectivity
* Load Balancer connectivity
* Target health validation
* EC2 network troubleshooting

APP01 was tested for private network connectivity without using a public IP address.

### 📸 Screenshot 20 — Network Connectivity Test

![Network Connectivity Test](20-connectivity-test.png)

### 📸 Screenshot 21 — Load Balancer Test

![Load Balancer Test](21-load-balancer-test.png)

### 📸 Screenshot 22 — Target Health

![Target Health](22-target-health.png)

---

## 🛠️ Technologies

**Cloud**

AWS

**Infrastructure**

Amazon VPC · EC2 · AWS Backup

**Networking**

VPC · Subnets · Route Tables · Internet Gateway · Security Groups · Load Balancing · Multi-AZ

**Identity**

IAM

**Monitoring**

CloudWatch

**Infrastructure as Code**

Terraform

**Operating Systems**

Windows Server · Linux

---

## 📚 Skills Demonstrated

* AWS infrastructure deployment
* VPC design
* Public and private subnet design
* Route Table management
* Internet Gateway configuration
* EC2 management
* Security Group configuration
* Application Load Balancing
* Multi-AZ architecture
* IAM management
* CloudWatch monitoring
* AWS Backup
* Terraform
* Infrastructure as Code
* Network troubleshooting
* Cloud infrastructure troubleshooting

---

## 🚀 Next Steps

Planned improvements for the AWS laboratory:

* AWS and Azure Hybrid Connectivity
* Active Directory integration
* Expanding the Terraform infrastructure
* Container technologies
* Docker
* Kubernetes
* Cloud automation
* AWS + Azure Hybrid Cloud

---

## 📌 Project Status

This laboratory is an ongoing hands-on cloud infrastructure project.

The environment will continue to evolve through additional AWS services, networking scenarios, automation, Infrastructure as Code, and troubleshooting exercises.
