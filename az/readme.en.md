# ☁️ Microsoft Azure Infrastructure Lab

Practical Azure infrastructure laboratory built to develop hands-on skills in cloud infrastructure, networking, security, identity, storage, and system administration.

The lab focuses on designing, configuring, testing, troubleshooting, and managing Azure resources in a realistic infrastructure environment.

---

## 📌 Project Overview

This laboratory covers the deployment and configuration of a small Azure infrastructure environment.

The project includes:

* Azure Virtual Network
* Subnets
* Network Security Groups
* Network routing
* Linux virtual machine
* Azure Storage
* Private Endpoint
* Private DNS
* Managed Identity
* Azure CLI
* Role-Based Access Control
* Azure Backup
* Management Locks
* Network troubleshooting

---

## 🏗️ Architecture

### Architecture Diagram

The environment contains an Azure Virtual Network with dedicated subnetting, network security controls, a Linux virtual machine, and private connectivity to Azure Storage.

Here's the diagram;
![Storage Access Test](az_diagram.jpg)

---

## 1. 🌐 Virtual Network & Subnets

The Azure networking environment was created using a dedicated Virtual Network and subnet structure.

### Configuration

| Resource        | Configuration     |
| --------------- | ----------------- |
| Resource Group  | `rg-az104-lab01`  |
| Virtual Network | `vnet-az104-tf01` |
| Address Space   | `10.10.0.0/16`    |
| Subnet          | `WebSubnet`       |
| Subnet Range    | `10.10.1.0/24`    |
| Region          | Sweden Central    |

### 📸 Screenshot 01 — Resource Group
![Storage Access Test](01-resource-group.png)

### 📸 Screenshot 02 — Virtual Network
![Storage Access Test](02-virtual-network.png)

### 📸 Screenshot 03 — Subnet Configuratio
![Storage Access Test](03-subnet.png)

---

## 2. 🔐 Network Security

Network traffic was controlled using Network Security Groups.

An NSG was associated with the WebSubnet to control inbound and outbound traffic.

### Configuration

* Network Security Group: `nsg-web-tf01`
* Subnet association: `WebSubnet`
* RDP access controlled through security rules
* HTTP access controlled through security rules
* Network access controlled through NSG rules

### 📸 Screenshot 04 — Network Security Group
![Storage Access Test](04-nsg.png)

### 📸 Screenshot 05 — NSG Inbound Rules
![Storage Access Test](05-nsg-rules.png)

---

## 3. 🖥️ Linux Virtual Machine

A Linux virtual machine was deployed inside the Azure Virtual Network.

### Configuration

| Resource         | Configuration       |
| ---------------- | ------------------- |
| VM Name          | `vm-web-tf01`       |
| OS               | Ubuntu 24.04 LTS    |
| Size             | `Standard_B2ats_v2` |
| Private IP       | `10.10.1.4`         |
| Managed Identity | System-assigned     |

The VM was used to test network connectivity, Azure services, identity, private DNS resolution, and storage access.

### 📸 Screenshot 06 — Virtual Machine Overview
![Storage Access Test](06-vm-overview.png)

### 📸 Screenshot 07 — VM Networking
![Storage Access Test](07-vm-networking.png)

---

## 4. 🛣️ Routing

Custom routing was configured to demonstrate Azure network traffic flow and next-hop behavior.

### Configuration

| Setting       | Value       |
| ------------- | ----------- |
| Route         | `0.0.0.0/0` |
| Next Hop Type | Internet    |

The routing configuration was used as part of the network laboratory and troubleshooting exercises.

### 📸 Screenshot 08 — Route Table
![Storage Access Test](08-route-table.png)

### 📸 Screenshot 09 — Route Configuration
![Storage Access Test](09-route.png)

---

## 5. 📦 Azure Storage

An Azure Storage Account was deployed and used to test secure access from the Azure virtual machine.

The storage environment includes Blob Storage, blob versioning, soft-delete retention, and private connectivity.

### 📸 Screenshot 10 — Storage Account
![Storage Access Test](10-storage-account.png)

### 📸 Screenshot 11 — Blob Storage
![Storage Access Test](11-blob-storage.png)

---

## 6. 🔗 Private Endpoint & Private DNS

A Private Endpoint was configured to provide private network connectivity to Azure Blob Storage.

### Configuration

| Resource         | Configuration                       |
| ---------------- | ----------------------------------- |
| Private Endpoint | `pe-storage-tf01`                   |
| Target           | Azure Storage Blob                  |
| Private IP       | `10.10.1.5`                         |
| Private DNS Zone | `privatelink.blob.core.windows.net` |

The Private DNS zone is centrally managed in the `rg-network-prod` resource group and linked to the lab Virtual Network.

This configuration demonstrates private access to Azure PaaS services without relying on a public endpoint.

### 📸 Screenshot 12 — Private Endpoint
![Storage Access Test](12-private-endpoint.png)

### 📸 Screenshot 13 — Private DNS Zone
![Storage Access Test](13-private-dns.png)

---

## 7. 🆔 Managed Identity & RBAC

A system-assigned Managed Identity was used to provide the virtual machine with controlled access to Azure resources without storing credentials directly on the VM.

The VM identity was assigned the required Azure RBAC permission for Blob Storage access.

### Role Assignment

* System-assigned Managed Identity
* Azure Storage
* `Storage Blob Data Reader`

The lab also includes a Resource Group Reader role assignment for the configured Azure AD / Microsoft Entra group.

### 📸 Screenshot 14 — Managed Identity
![Storage Access Test](14-managed-identity.png)

### 📸 Screenshot 15 — Role Assignment
![Storage Access Test](15-role-assignment.png)

---

## 8. 🔒 Management Lock & Backup

A resource lock was configured to prevent accidental deletion of the lab Resource Group.

### Configuration

* Management Lock: `lock-az104-tf01`
* Lock Type: `CanNotDelete`

Azure Backup was also configured for the virtual machine and the backup status was verified successfully.

### 📸 Screenshot 16 — Management Lock
![Storage Access Test](16-management-lock.png)

### 📸 Screenshot 17 — Backup / Recovery
![Storage Access Test](17-backup-recovery.png)

---

## 9. 🧪 Testing & Troubleshooting

The environment was tested through practical troubleshooting scenarios.

Testing included:

* Network connectivity
* Private IP communication
* NSG rule validation
* Route validation
* Private Endpoint connectivity
* Private DNS resolution
* Managed Identity authentication
* Azure Storage access
* Azure Backup validation
* Management Lock validation

Private DNS resolution was tested directly from the Ubuntu VM using `nslookup`.

The Storage Account endpoint resolved through the Private Link DNS namespace to the Private Endpoint's private IP address.

```text
az104tflab3531.blob.core.windows.net
        ↓
az104tflab3531.privatelink.blob.core.windows.net
        ↓
10.10.1.5
```

Storage access was then tested from the VM using its system-assigned managed identity.

```bash
az login --identity

az storage blob list \
  --account-name az104tflab3531 \
  --container-name lab-data \
  --auth-mode login \
  -o table
```

The command successfully returned the blob stored in the `lab-data` container.

### 📸 Screenshot 18 — SSH Connection Test
![Storage Access Test](18-connectivity-test.png)

### 📸 Screenshot 19 — Private DNS Resolution
![Storage Access Test](18-dns-test.png)

### 📸 Screenshot 20 — Storage Access Test
![Storage Access Test](19-storage-test.png)

---

## 🛠️ Technologies

**Cloud**

Azure

**Infrastructure**

Azure Virtual Network · Virtual Machines · Azure Storage · Azure Backup

**Networking**

VNet · Subnets · Routing · NSGs · Private Endpoints · Private DNS

**Identity**

Managed Identity · Azure RBAC · Microsoft Entra ID

**Operating Systems**

Ubuntu 24.04 LTS

**Automation / Administration**

Azure CLI · PowerShell · Terraform

---

## 📚 Skills Demonstrated

* Azure infrastructure deployment
* Virtual networking
* Subnet design
* Network security
* Routing
* Linux / Ubuntu VM administration
* Azure Storage
* Private Endpoint configuration
* Private DNS
* Managed Identity
* RBAC
* Microsoft Entra ID
* Azure Backup
* Management Locks
* Azure CLI
* Terraform
* Network troubleshooting
* Cloud infrastructure troubleshooting

---

## 🚀 Next Steps

Planned extensions to the Azure laboratory:

* Azure Active Directory / Microsoft Entra ID integration
* Hybrid identity with on-premises Active Directory
* Azure networking expansion
* Azure monitoring
* Advanced Infrastructure as Code with Terraform
* AWS + Azure hybrid connectivity

---

## 📌 Project Status

This laboratory is an ongoing practical cloud infrastructure project.

The environment is continuously expanded with new Azure services, networking scenarios, automation, Infrastructure as Code, and troubleshooting exercises.
