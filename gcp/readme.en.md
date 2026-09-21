# ☁️ Google Cloud Platform Infrastructure Lab

A practical GCP infrastructure laboratory created to develop hands-on skills in cloud infrastructure, networking, security, load balancing, identity, monitoring, backup, storage, autoscaling, and hybrid connectivity.

The main goal of this laboratory is to build, configure, test, and troubleshoot a realistic GCP infrastructure environment.

---

## 📌 Project Overview

This laboratory covers the design and management of a small-scale GCP infrastructure environment using public and private subnets.

The project covers the following areas:

* Google Cloud VPC
* Public and private subnets
* Firewall Rules
* Compute Engine
* Global Application Load Balancer
* Managed Instance Group
* Autoscaling
* Cloud Storage
* IAM
* Service Accounts
* Cloud DNS
* Private Google Access
* Cloud Monitoring
* Alerting
* Backup and DR
* Storage Lifecycle Management
* Resource Protection
* AWS ↔ GCP private connectivity
* Network troubleshooting

---

## 🏗️ Architecture

### Architecture Diagram

![GCP Architecture](gcp_diagram.png)

The environment consists of a VPC with public and private subnets, two web servers, a private application server, and a public-facing Global Application Load Balancer.

WEB01 and WEB02 handle web traffic through the Load Balancer.

APP01 is deployed inside a private subnet and does not have a public IP address.

The environment also includes a Managed Instance Group with CPU-based autoscaling.

AWS and GCP private networks are connected through Tailscale for cross-cloud connectivity testing.

---

## 1. 🌐 VPC & Subnets

The GCP networking infrastructure was created using a custom VPC with separate public and private subnets.

### Configuration

| Resource       | Configuration        |
| -------------- | -------------------- |
| Region         | `europe-west3`       |
| VPC            | `gcp-lab-vpc`        |
| Public Subnet  | `gcp-public-subnet`  |
| Public CIDR    | `10.4.0.0/24`        |
| Private Subnet | `gcp-private-subnet` |
| Private CIDR   | `10.4.1.0/24`        |

WEB01 and WEB02 are located in the public subnet, while APP01 is located inside the private subnet.

### 📸 Screenshot 01 — VPC

![VPC](01-vpc.png)

### 📸 Screenshot 02 — Subnets

![Subnets](02-subnets.png)

### 📸 Screenshot 03 — Firewall Rules

![Firewall Rules](03-firewall-rules.png)

---

## 2. 🖥️ Compute Engine Infrastructure

Compute Engine instances were created to represent the web and application layers of the GCP environment.

### Configuration

| Server      | Role               | Network        |
| ----------- | ------------------ | -------------- |
| `gcp-web01` | Web Server         | Public Subnet  |
| `gcp-web02` | Web Server         | Public Subnet  |
| `gcp-app01` | Application Server | Private Subnet |

WEB01 and WEB02 provide the web tier, while APP01 provides the private backend application layer.

### 📸 Screenshot 04 — WEB01

![WEB01](04-web01.png)

### 📸 Screenshot 05 — WEB02

![WEB02](05-web02.png)

### 📸 Screenshot 06 — APP01

![APP01](06-app01.png)

---

## 3. ⚖️ Global Application Load Balancer

A Global External Application Load Balancer was configured to distribute HTTP traffic across the web tier.

The Load Balancer uses the Managed Instance Group as a backend and performs HTTP health checks through the `/health` endpoint.

### Configuration

| Resource      | Configuration                             |
| ------------- | ----------------------------------------- |
| Load Balancer | Global External Application Load Balancer |
| Frontend      | HTTP                                      |
| Backend       | `gcp-web-backend`                         |
| Health Check  | `gcp-web-health`                          |
| Backend       | `gcp-web-mig`                             |

### 📸 Screenshot 07 — Load Balancer

![Load Balancer](07-load-balancer.png)

### 📸 Screenshot 08 — Backend Service

![Backend Service](08-backend-service.png)

### 📸 Screenshot 09 — Health Check

![Health Check](09-health-check.png)

---

## 4. 📈 Managed Instance Group & Autoscaling

A Managed Instance Group was configured for the web tier.

The MIG uses an instance template and automatically creates additional instances when CPU utilization exceeds the configured target.

### Configuration

| Resource          | Configuration         |
| ----------------- | --------------------- |
| MIG               | `gcp-web-mig`         |
| Region            | `europe-west3`        |
| Zone              | `europe-west3-a`      |
| Minimum instances | `2`                   |
| Maximum instances | `4`                   |
| CPU target        | `60%`                 |
| Instance template | `gcp-web-template-v2` |

Autoscaling was tested by generating CPU load on a MIG instance.

The group successfully scaled from **2 to 4 instances**.

### 📸 Screenshot 10 — Managed Instance Group

![MIG](10-mig.png)

### 📸 Screenshot 11 — Autoscaling

![Autoscaling](11-autoscaling.png)

---

## 5. 🗄️ Cloud Storage

Cloud Storage was configured as the object storage layer of the environment.

### Configuration

| Resource       | Configuration               |
| -------------- | --------------------------- |
| Bucket         | `gcp-lab-storage-20260920`  |
| Location       | `europe-west3`              |
| Storage Class  | Standard                    |
| Public Access  | Not public                  |
| Access Control | Uniform bucket-level access |

A test object was created and accessed from APP01 through the dedicated VM Service Account.

### 📸 Screenshot 12 — Cloud Storage Bucket

![Cloud Storage](12-storage.png)

### 📸 Screenshot 13 — Storage Object

![Storage Object](13-storage-object.png)

---

## 6. ♻️ Storage Lifecycle Management

Cloud Storage Lifecycle Management was configured to automatically move objects to colder storage classes based on object age.

### Lifecycle Rules

| Object Age | Storage Class |
| ---------- | ------------- |
| 30+ days   | Nearline      |
| 60+ days   | Coldline      |
| 90+ days   | Archive       |

This demonstrates automated storage tier management for long-term data retention.

### 📸 Screenshot 14 — Lifecycle Rules

![Lifecycle Rules](14-lifecycle.png)

---

## 7. 🆔 IAM & Service Accounts

Google Cloud IAM was used to control access to cloud resources.

A dedicated Service Account was created for the GCP lab VM and granted the minimum required access to Cloud Storage.

### Topics Covered

* IAM Users
* Least privilege
* Bucket-level permissions
* Service Accounts
* VM identity
* Storage Object Viewer

The VM Service Account was used by APP01/WEB01 to access the Cloud Storage bucket without using user credentials.

### 📸 Screenshot 15 — IAM

![IAM](15-iam.png)

### 📸 Screenshot 16 — Service Account

![Service Account](16-service-account.png)

### 📸 Screenshot 17 — Bucket Permissions

![Bucket Permissions](17-bucket-permissions.png)

---

## 8. 🌐 Private DNS

Cloud DNS was configured with a private DNS zone for the GCP VPC.

### Configuration

| Resource | Configuration                   |
| -------- | ------------------------------- |
| DNS Zone | `gcp-private-zone`              |
| DNS Name | `gcp.internal.`                 |
| Network  | `gcp-lab-vpc`                   |
| Record   | `web01.gcp.internal → 10.4.0.2` |

The private DNS name was successfully resolved from inside the VPC.

### 📸 Screenshot 18 — Private DNS Zone

![Private DNS](18-private-dns.png)

### 📸 Screenshot 19 — DNS Record

![DNS Record](19-dns-record.png)

---

## 9. 🔒 Private Google Access

Private Google Access was enabled on the private subnet.

This allows instances without external IP addresses to access supported Google APIs and services.

APP01 successfully accessed Cloud Storage without requiring a public IP address.

### 📸 Screenshot 20 — Private Google Access

![Private Google Access](20-private-google-access.png)

---

## 10. 📊 Monitoring & Alerting

Cloud Monitoring was used to monitor Compute Engine metrics.

A CPU utilization alert policy was configured for WEB01.

### Topics Covered

* Metrics Explorer
* VM CPU monitoring
* Alert policies
* Email notifications
* Threshold-based alerting

The alerting system was tested and email notifications were successfully received.

### 📸 Screenshot 21 — Monitoring Metric

![Monitoring](21-monitoring.png)

### 📸 Screenshot 22 — Alert Policy

![Alert Policy](22-alert-policy.png)

---

## 11. 💾 Backup & Disaster Recovery

Google Cloud Backup and DR was configured to protect APP01.

A Backup Vault and backup plan were created with scheduled daily backups.

### Configuration

| Resource       | Configuration      |
| -------------- | ------------------ |
| Backup Vault   | `gcp-lab-vault`    |
| Location       | `europe-west3`     |
| Backup Plan    | `gcp-app01-backup` |
| Schedule       | Daily              |
| Retention      | 14 days            |
| Disk Inclusion | All disks          |

### 📸 Screenshot 23 — Backup Vault

![Backup Vault](23-backup-vault.png)

### 📸 Screenshot 24 — Backup Plan

![Backup Plan](24-backup-plan.png)

### 📸 Screenshot 25 — Protected Resource

![Protected Resource](25-protected-resource.png)

---

## 12. 🛡️ Resource Protection

Deletion protection was enabled on APP01 to prevent accidental VM deletion.

### Configuration

| Resource    | Protection                  |
| ----------- | --------------------------- |
| `gcp-app01` | Deletion Protection Enabled |

### 📸 Screenshot 26 — Deletion Protection

![Deletion Protection](26-deletion-protection.png)

---

## 13. 🔗 AWS ↔ GCP Private Connectivity

Private network connectivity between AWS and GCP was configured using Tailscale.

The connection was tested using the private IP addresses of the web servers.

### Configuration

| Cloud     | Private IP   | Tailscale IP    |
| --------- | ------------ | --------------- |
| AWS WEB01 | `10.0.1.124` | `100.64.158.13` |
| GCP WEB01 | `10.4.0.2`   | `100.64.235.92` |

Routing between the AWS and GCP private networks was configured and tested successfully.

### 📸 Screenshot 27 — Tailscale Connectivity

![Tailscale Connectivity](27-tailscale-connectivity.png)

### 📸 Screenshot 28 — Private IP Connectivity Test

![Private Connectivity](28-private-connectivity.png)

---

## 14. 🧪 Testing & Troubleshooting

The GCP environment was tested through realistic networking, storage, load balancing, and infrastructure troubleshooting scenarios.

Tests included:

* VPC connectivity
* Public and private subnet connectivity
* WEB → APP connectivity
* Load Balancer connectivity
* Backend health validation
* Cloud Storage access
* Service Account permissions
* Private DNS resolution
* Private Google Access
* Autoscaling
* AWS ↔ GCP connectivity
* Backup configuration validation
* Firewall rule validation

### 📸 Screenshot 29 — Network Connectivity Test

![Network Connectivity Test](29-connectivity-test.png)

### 📸 Screenshot 30 — Load Balancer Test

![Load Balancer Test](30-load-balancer-test.png)

### 📸 Screenshot 31 — Autoscaling Test

![Autoscaling Test](31-autoscaling-test.png)

---

## 🛠️ Technologies

**Cloud**

Google Cloud Platform

**Compute**

Compute Engine · Managed Instance Groups

**Networking**

VPC · Subnets · Firewall Rules · Cloud DNS · Load Balancing · Tailscale

**Storage**

Cloud Storage · Nearline · Coldline · Archive · Lifecycle Management

**Identity**

IAM · Service Accounts

**Monitoring**

Cloud Monitoring · Alerting

**Backup**

Backup and DR · Backup Vault

**Operating Systems**

Ubuntu Linux

---

## 📚 Skills Demonstrated

* GCP infrastructure deployment
* VPC and subnet design
* Firewall configuration
* Compute Engine management
* Global Load Balancing
* Managed Instance Groups
* Autoscaling
* Cloud Storage management
* Storage lifecycle management
* IAM and least-privilege access
* Service Account configuration
* Private DNS
* Private Google Access
* Cloud Monitoring
* Alerting
* Backup and Disaster Recovery
* Resource protection
* Cross-cloud network connectivity
* Network troubleshooting
* Cloud infrastructure troubleshooting

---

## 🚀 Next Steps

Planned improvements for the GCP laboratory:

* GCP Terraform infrastructure
* Expanding hybrid cloud connectivity
* Container technologies
* Docker
* Kubernetes
* Cloud automation
* Multi-cloud Infrastructure as Code

---

## 📌 Project Status

This laboratory is an ongoing hands-on cloud infrastructure project.

The GCP environment will continue to evolve through additional cloud services, networking scenarios, automation, Infrastructure as Code, and troubleshooting exercises.
