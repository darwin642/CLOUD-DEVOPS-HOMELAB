# GCP Terraform Implementation

## Overview

This section documents the use of **Terraform** to manage an existing **Google Cloud Platform (GCP)** environment as Infrastructure as Code (IaC).

Unlike a traditional Terraform deployment where infrastructure is created entirely from configuration files, this implementation focuses on importing an already existing GCP environment into Terraform, synchronizing the Terraform state with the actual infrastructure, identifying configuration drift, and aligning the Terraform configuration with the existing resources.

The environment contains networking, compute instances, managed instance groups, load balancing, autoscaling, Cloud Storage, IAM, private DNS, monitoring, and backup resources.

The final objective of this implementation is to ensure that Terraform accurately represents the existing infrastructure and that:

```text
terraform plan
```

returns:

```text
No changes
```

This confirms that the Terraform configuration and the deployed GCP infrastructure are synchronized.

---

# 1. Provider Configuration and Variables

The Google Cloud provider is configured to manage resources inside the existing GCP project.

### Provider Configuration

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
```

The environment uses the following configuration:

| Setting         | Value                            |
| --------------- | -------------------------------- |
| Cloud Provider  | Google Cloud Platform            |
| Project         | `project-aed44365-ff0a-48b4-b75` |
| Region          | `europe-west3`                   |
| Zone            | `europe-west3-a`                 |
| Google Provider | `~> 7.0`                         |
| Terraform       | `1.15.8`                         |

### Code Explanation

* `required_providers` defines the Google provider used by Terraform.
* `project` identifies the GCP project containing the infrastructure.
* `region` defines the primary regional location.
* `zone` defines the zone used by the compute instances.
* Provider version `~> 7.0` keeps the configuration within the Google provider 7.x series.

---

# 2. Existing Infrastructure and Terraform Import

The GCP environment was already deployed before Terraform management was established.

Instead of recreating the infrastructure, the existing resources were imported into Terraform.

The overall workflow was:

```text
Existing GCP Infrastructure
          │
          ▼
     Terraform Import
          │
          ▼
     Terraform State
          │
          ▼
      Drift Detection
          │
          ▼
 Configuration Alignment
          │
          ▼
    terraform plan
          │
          ▼
      No changes
```

This approach allows Terraform to become the management layer for infrastructure that already exists.

### Terraform Import

Resources were imported into the Terraform state using commands similar to:

```powershell
terraform import google_compute_network.lab_vpc <resource-id>
```

```powershell
terraform import google_compute_instance.web01 <resource-id>
```

```powershell
terraform import google_compute_instance.web02 <resource-id>
```

```powershell
terraform import google_compute_instance.app01 <resource-id>
```

The same process was applied to the networking, load balancing, storage, IAM, monitoring, DNS, scaling, and backup resources.

### Code Explanation

Terraform import performs two important actions:

* Connects an existing cloud resource to a Terraform resource address.
* Stores the resource information inside Terraform state.

Importing does **not** automatically create Terraform configuration.

The configuration must still be written so that it accurately represents the imported infrastructure.

---

# 3. VPC and Network

The GCP environment uses a dedicated VPC named:

```text
lab_vpc
```

Terraform manages the VPC through:

```hcl
resource "google_compute_network" "lab_vpc" {
  name                    = "..."
  auto_create_subnetworks = false
}
```

The VPC uses custom subnet mode so that subnet ranges and regional placement can be explicitly controlled.

### Network Design

```text
                    GCP PROJECT
                         │
                         ▼
                 ┌───────────────┐
                 │    lab_vpc    │
                 │ Custom VPC    │
                 └───────┬───────┘
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
      ┌───────────────┐     ┌───────────────┐
      │ public_subnet │     │ private_subnet│
      └───────────────┘     └───────────────┘
              │                     │
         WEB01 / WEB02            APP01
```

The custom VPC provides the foundation for the rest of the environment.

---

# 4. Subnet Architecture

Two regional subnets are managed by Terraform:

* `public_subnet`
* `private_subnet`

Both subnets are located in:

```text
europe-west3
```

Private Google Access is enabled on the subnets.

```hcl
resource "google_compute_subnetwork" "public_subnet" {
  name                     = "..."
  region                   = var.region
  network                  = google_compute_network.lab_vpc.id
  private_ip_google_access = true
}
```

The same capability is configured for the private subnet.

### Private Google Access

Private Google Access allows instances without external IP addresses to access supported Google APIs and services through Google's infrastructure.

This is particularly useful for private workloads that need access to services such as Cloud Storage without requiring public IP addressing.

---

# 5. Firewall and Network Security

Several firewall rules are managed through Terraform to control communication between the different components.

The environment contains rules for:

| Firewall Rule      | Purpose                          |
| ------------------ | -------------------------------- |
| `allow_http`       | HTTP access to web services      |
| `allow_iap_ssh`    | SSH connectivity through IAP     |
| `allow_web_to_app` | Web-to-application communication |
| `allow_app_5000`   | Application traffic on port 5000 |
| `app2_http_ns`     | Application HTTP traffic         |

### Web-to-Application Communication

The environment separates web and application workloads.

```text
Internet
   │
   ▼
Load Balancer
   │
   ├──────────────┐
   ▼              ▼
 WEB01          WEB02
   │              │
   └──────┬───────┘
          │
          │ Application traffic
          ▼
        APP01
```

The `allow_web_to_app` firewall rule controls the required communication between the web and application layers.

This demonstrates network segmentation rather than allowing unrestricted communication between all workloads.

---

# 6. Compute Instances

The environment contains three primary Compute Engine instances:

| Instance | Role                 |
| -------- | -------------------- |
| `web01`  | Web workload         |
| `web02`  | Web workload         |
| `app01`  | Application workload |

Terraform manages each instance as an individual resource.

Example:

```hcl
resource "google_compute_instance" "web01" {
  name         = "..."
  machine_type = "..."

  zone = var.zone

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.id
  }
}
```

### Web Layer

WEB01 and WEB02 provide the web-facing workload.

They are placed behind the Google Cloud load balancer so that incoming traffic can be distributed across multiple instances.

### Application Layer

APP01 provides the application workload.

It is placed in the private portion of the architecture and is accessed by the web layer rather than directly exposed to the Internet.

---

# 7. Instance Template

A regional Compute Engine instance template is managed by Terraform:

```text
google_compute_region_instance_template.web_template
```

The instance template provides a reusable definition for web instances managed by the Managed Instance Group.

Conceptually:

```text
Instance Template
       │
       ▼
Managed Instance Group
       │
   ┌───┴───┐
   ▼       ▼
 WEB01   WEB02
```

The template allows the configuration of new instances to remain consistent.

---

# 8. Managed Instance Group

The environment contains a Managed Instance Group:

```text
web_mig
```

Terraform manages:

```hcl
resource "google_compute_region_instance_group_manager" "web_mig" {
  name = "..."

  target_size = 2
}
```

The current target size is:

```text
2 instances
```

The Managed Instance Group provides a controlled mechanism for maintaining multiple instances based on the configured instance template.

### Benefits

The MIG provides:

* Consistent instance configuration
* Centralized instance management
* Integration with autoscaling
* Better availability for the web layer
* Automated instance replacement capabilities

---

# 9. Autoscaling

Autoscaling is configured for the web Managed Instance Group.

Terraform manages:

```text
google_compute_autoscaler.web_mig
```

The autoscaler can adjust the number of instances in the Managed Instance Group according to the configured scaling policy.

```text
                 Load / Utilization
                         │
                         ▼
                   Autoscaler
                         │
             ┌───────────┴───────────┐
             ▼                       ▼
       Scale Out                 Scale In
             │                       │
             ▼                       ▼
       More WEB VMs              Fewer WEB VMs
```

This provides an automated scaling mechanism for the web tier.

---

# 10. Load Balancing

The GCP environment contains a global HTTP load balancer.

Terraform manages the following components:

```text
google_compute_health_check.web_health
google_compute_backend_service.web_backend
google_compute_url_map.web_lb
google_compute_target_http_proxy.web_lb
google_compute_global_forwarding_rule.web_lb
```

### Load Balancer Architecture

```text
                         INTERNET
                            │
                            ▼
                 Global Forwarding Rule
                            │
                            ▼
                    Target HTTP Proxy
                            │
                            ▼
                        URL Map
                            │
                            ▼
                    Backend Service
                            │
                  ┌─────────┴─────────┐
                  ▼                   ▼
                WEB01               WEB02
```

The global forwarding rule receives incoming traffic and passes it through the HTTP load-balancing components toward the backend service.

---

# 11. Health Check

The backend service uses a Google Cloud health check:

```text
web_health
```

The health check verifies whether the web backend is available.

```text
Load Balancer
      │
      ▼
 Health Check
      │
 ┌────┴────┐
 ▼         ▼
WEB01     WEB02
```

Only healthy backends should receive normal load-balancing traffic.

This provides an additional availability layer for the web workload.

---

# 12. Web-to-Application Communication

The web and application layers are separated logically inside the VPC.

```text
                    INTERNET
                       │
                       ▼
                 LOAD BALANCER
                       │
              ┌────────┴────────┐
              ▼                 ▼
            WEB01             WEB02
              │                 │
              └────────┬────────┘
                       │
                 Firewall Rule
                allow_web_to_app
                       │
                       ▼
                     APP01
```

The application workload does not need to be directly exposed to the Internet.

Instead, communication is controlled through firewall rules between the web and application layers.

This demonstrates a basic multi-tier application architecture.

---

# 13. Cloud Storage

The environment contains a Google Cloud Storage bucket managed through Terraform.

Bucket:

```text
gcp-lab-storage-20260920
```

The bucket is configured with:

* Standard storage class
* Europe-West3 location
* Uniform bucket-level access
* Public access prevention
* Soft delete
* Lifecycle management

### Lifecycle Management

Objects are transitioned between storage classes according to their age.

| Object Age | Storage Class |
| ---------- | ------------- |
| 30 days    | Nearline      |
| 60 days    | Coldline      |
| 90 days    | Archive       |

Conceptually:

```text
STANDARD
   │
   │ 30 days
   ▼
NEARLINE
   │
   │ 60 days
   ▼
COLDLINE
   │
   │ 90 days
   ▼
ARCHIVE
```

This demonstrates automated storage lifecycle management.

### Bucket Security

Public access prevention is enabled so that objects cannot accidentally become publicly accessible.

Uniform bucket-level access is also enabled to simplify IAM-based access control.

---

# 14. Cloud Storage IAM

Terraform manages bucket-level IAM permissions through:

```text
google_storage_bucket_iam_binding.lab_object_viewer
```

The configured role is:

```text
roles/storage.objectViewer
```

Access is granted to:

* The GCP VM service account
* The configured user account

This allows authorized identities to read objects without granting unnecessary administrative permissions.

---

# 15. Service Account and IAM

The environment contains a dedicated service account:

```text
gcp-lab-vm
```

The service account is used by the lab VM environment.

Terraform manages:

```hcl
resource "google_service_account" "vm_service_account" {
  account_id   = "gcp-lab-vm"
  display_name = "GCP Lab VM Service Account"
}
```

The service account is also granted the required Cloud Storage permissions.

This demonstrates identity-based access instead of relying on broad project-level permissions.

---

# 16. Private DNS

The environment contains a private Cloud DNS managed zone:

```text
gcp-private-zone
```

DNS suffix:

```text
gcp.internal.
```

The zone is configured for private visibility.

Terraform manages:

```text
google_dns_managed_zone.gcp_private_zone
google_dns_record_set.web01
```

The WEB01 record is:

```text
web01.gcp.internal.
```

and resolves to the private address of WEB01.

Conceptually:

```text
web01.gcp.internal.
          │
          ▼
      Private DNS
          │
          ▼
      WEB01
```

This provides internal name resolution without exposing the DNS record publicly.

---

# 17. Monitoring and Alerting

Cloud Monitoring is used to monitor the web workload.

Terraform manages:

```text
google_monitoring_alert_policy.web01_80_cpu
```

The alert policy monitors CPU utilization for WEB01.

### Alert Configuration

| Setting       | Value                        |
| ------------- | ---------------------------- |
| Policy        | `web01_80_cpu`               |
| Severity      | WARNING                      |
| Metric        | GCE instance CPU utilization |
| Threshold     | 80%                          |
| Alignment     | 60 seconds                   |
| Trigger Count | 1                            |
| Notification  | Email                        |

The alert is intended to notify the configured email notification channel when WEB01 CPU utilization exceeds the defined threshold.

Conceptually:

```text
WEB01
  │
  ▼
CPU Utilization
  │
  ▼
> 80%
  │
  ▼
Cloud Monitoring
  │
  ▼
Alert Policy
  │
  ▼
Email Notification
```

This demonstrates infrastructure monitoring and event notification through Terraform-managed configuration.

---

# 18. Backup Vault

The environment uses Google Cloud Backup and DR for VM protection.

Terraform manages the backup vault:

```text
gcp-lab-vault
```

The vault is located in:

```text
europe-west3
```

The vault uses organization-level access restrictions and a minimum retention period.

The vault provides the storage location for protected Compute Engine backups.

---

# 19. Backup Plan

A backup plan named:

```text
gcp-app01-backup
```

is configured for Compute Engine instances.

### Backup Configuration

| Setting       | Value                   |
| ------------- | ----------------------- |
| Location      | `europe-west3`          |
| Resource Type | Compute Engine Instance |
| Frequency     | Daily                   |
| Time Zone     | Europe/Berlin           |
| Backup Window | 00:00–06:00             |
| Retention     | 14 days                 |
| Backup Vault  | `gcp-lab-vault`         |

The backup architecture is:

```text
                    APP01
                      │
                      ▼
                Backup Plan
                      │
                      ▼
                Backup Rule
                      │
                      ▼
                Backup Vault
                      │
                      ▼
                Retained Backups
```

This provides scheduled protection for APP01.

---

# 20. Backup Plan Association

The backup plan is associated with APP01 through:

```text
google_backup_dr_backup_plan_association.app01
```

The association is currently active and the latest recorded backup completed successfully.

The relationship can be represented as:

```text
APP01
 │
 ▼
Backup Plan Association
 │
 ▼
gcp-app01-backup
 │
 ▼
gcp-lab-vault
```

This connects the Compute Engine workload to the backup policy and vault.

---

# 21. Terraform State

Terraform state is the connection between Terraform configuration and the real GCP infrastructure.

The current Terraform state contains the imported infrastructure resources.

The state includes resources for:

```text
Networking
Compute
Load Balancing
Autoscaling
Storage
IAM
DNS
Monitoring
Backup
```

The state can be inspected with:

```powershell
terraform state list
```

The final environment contains 30 Terraform-managed resources.

The state therefore provides Terraform with a representation of the existing GCP environment.

---

# 22. Terraform Drift Detection

After importing the resources, the configuration was compared against the real infrastructure.

The workflow was:

```text
Terraform Configuration
          │
          ▼
    terraform plan
          │
          ▼
Compare with State
          │
          ▼
Compare with GCP
          │
          ▼
Identify Differences
          │
          ▼
Update Configuration
```

During this process, Terraform identified differences between the existing infrastructure and the initial configuration.

One example was the Managed Instance Group target size.

The existing environment used:

```text
target_size = 2
```

The Terraform configuration was aligned accordingly.

This demonstrates how Terraform can be used not only for provisioning but also for detecting and reconciling infrastructure drift.

---

# 23. Backup Association State Handling

During the import process, the Backup Plan Association exposed a provider/state synchronization issue.

The GCP API correctly reported the Compute Engine resource associated with the backup plan, while the imported Terraform state did not retain the same `resource` value.

The required configuration remained present:

```hcl
resource = google_compute_instance.app01.id
```

The following lifecycle configuration was then used:

```hcl
lifecycle {
  ignore_changes = [resource]
}
```

This allowed Terraform to retain the required configuration while preventing the provider's observed state difference from producing a persistent plan change.

After this adjustment, the resource no longer produced a difference during planning.

This is documented as an observed provider/state synchronization behavior rather than a change to the actual backup configuration.

---

# 24. Terraform Validation Workflow

The final validation process uses:

```powershell
terraform fmt
```

```powershell
terraform validate
```

```powershell
terraform plan
```

The most important final result is:

```text
No changes
```

This means Terraform has determined that the configuration matches the resources represented in the Terraform state and no infrastructure modifications are currently required.

The final workflow is:

```text
terraform fmt
      │
      ▼
terraform validate
      │
      ▼
terraform plan
      │
      ▼
   No changes
```

No infrastructure recreation is required for the final synchronization state.

---

# 25. Infrastructure as Code Model

The GCP implementation demonstrates an Infrastructure as Code workflow based on an existing cloud environment.

```text
                 EXISTING GCP
                     │
                     ▼
               Resource Import
                     │
                     ▼
              Terraform State
                     │
                     ▼
              Configuration
                     │
                     ▼
              Drift Detection
                     │
                     ▼
             Configuration Fixes
                     │
                     ▼
               Terraform Plan
                     │
                     ▼
                 No Changes
```

The important concept is that Terraform is not limited to creating new infrastructure.

It can also be used to bring existing infrastructure under code-based management.

The final configuration provides a reproducible representation of the GCP environment while maintaining the existing deployed resources.

---

# 26. Managed GCP Resources

The final Terraform state contains the following resource categories:

| Category            | Managed Resources                                                   |
| ------------------- | ------------------------------------------------------------------- |
| Networking          | VPC, Public Subnet, Private Subnet                                  |
| Firewall            | HTTP, IAP SSH, Web-to-App, Application rules                        |
| Compute             | WEB01, WEB02, APP01                                                 |
| Instance Management | Instance Template, Managed Instance Group                           |
| Scaling             | Autoscaler                                                          |
| Load Balancing      | Health Check, Backend Service, URL Map, HTTP Proxy, Forwarding Rule |
| Storage             | Cloud Storage Bucket                                                |
| IAM                 | Service Account, Storage IAM Binding                                |
| DNS                 | Private DNS Zone, WEB01 Record                                      |
| Monitoring          | CPU Alert Policy                                                    |
| Backup              | Backup Vault, Backup Plan, Plan Association                         |

---

# 27. Final Architecture

The complete GCP environment can be represented as:

```text
                           INTERNET
                              │
                              ▼
                  ┌─────────────────────┐
                  │ Global Forwarding   │
                  │       Rule          │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │  Target HTTP Proxy  │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │       URL Map       │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │   Backend Service   │
                  └──────────┬──────────┘
                             │
                  ┌──────────┴──────────┐
                  │                     │
                  ▼                     ▼
             ┌─────────┐           ┌─────────┐
             │  WEB01  │           │  WEB02  │
             └────┬────┘           └────┬────┘
                  │                     │
                  └──────────┬──────────┘
                             │
                      Web-to-App FW
                             │
                             ▼
                       ┌─────────┐
                       │  APP01  │
                       └─────────┘

        ┌────────────────────────────────────────┐
        │                lab_vpc                 │
        │                                        │
        │  ┌────────────────┐ ┌───────────────┐ │
        │  │ public_subnet  │ │private_subnet │ │
        │  │ WEB01 / WEB02  │ │     APP01     │ │
        │  └────────────────┘ └───────────────┘ │
        │                                        │
        │  Private Google Access                 │
        │  Private Cloud DNS                     │
        └────────────────────────────────────────┘

        ┌────────────────────────────────────────┐
        │ Additional GCP Services                │
        │                                        │
        │ Cloud Storage                          │
        │ IAM Service Account                    │
        │ Cloud Monitoring                       │
        │ Backup Vault                           │
        │ Backup Plan                            │
        │ Autoscaler / MIG                       │
        └────────────────────────────────────────┘
```

---

# Conclusion

This Terraform implementation demonstrates the management of an existing GCP environment using Infrastructure as Code.

The lab covers:

* Existing infrastructure import
* Terraform state management
* VPC and subnet configuration
* Firewall rules
* Compute Engine
* Managed Instance Groups
* Autoscaling
* Global HTTP Load Balancing
* Cloud Storage lifecycle management
* IAM and service accounts
* Private Cloud DNS
* Private Google Access
* Cloud Monitoring
* Backup and Disaster Recovery
* Infrastructure drift detection
* Provider/state synchronization handling
* Terraform validation

The final state of the project is validated through:

```powershell
terraform plan
```

with the result:

```text
No changes
```

This confirms that the Terraform configuration is synchronized with the existing GCP infrastructure and that Terraform can accurately represent and manage the environment as code.
