# ☁️ Microsoft Azure Infrastructure Lab

Practical Azure infrastructure laboratory built to develop hands-on skills in cloud infrastructure, networking, security, identity, storage, and system administration.

The lab focuses on designing, configuring, testing, and troubleshooting Azure resources in a realistic infrastructure environment.

---

## 📌 Project Overview

This laboratory covers the deployment and configuration of a small Azure infrastructure environment.

The project includes:

* Azure Virtual Network
* Subnets
* Network Security Groups
* Network routing
* Windows Server virtual machine
* Azure Storage
* Private Endpoint
* Private DNS
* Managed Identity
* Azure CLI
* Role-Based Access Control
* Network troubleshooting

---

## 🏗️ Architecture

### Architecture Diagram

> **[YOUR AZURE ARCHITECTURE DIAGRAM HERE]**

![Azure Architecture](./az_diagram.jpg)

The environment contains an Azure Virtual Network with dedicated subnetting, a Windows Server virtual machine, network security controls, and private connectivity to Azure Storage.

---

## 1. 🌐 Virtual Network & Subnets

The Azure networking environment was created using a dedicated Virtual Network and subnet structure.

### Configuration

| Resource        | Configuration      |
| --------------- | ------------------ |
| Resource Group  | `rg-az104-lab01`   |
| Virtual Network | `vnet-az104-lab01` |
| Address Space   | `10.0.0.0/16`      |
| Subnet          | `WebSubnet`        |
| Subnet Range    | `10.0.1.0/24`      |
| Region          | Sweden Central     |

### 📸 Screenshot 01 — Resource Group

![Resource Group](./images/01-resource-group.png)

### 📸 Screenshot 02 — Virtual Network

![Virtual Network](./images/02-virtual-network.png)

### 📸 Screenshot 03 — Subnet Configuration

![Subnet Configuration](./images/03-subnet.png)

---

## 2. 🔐 Network Security

Network traffic was controlled using Network Security Groups.

An NSG was associated with the WebSubnet to control inbound and outbound traffic.

### Configuration

* Network Security Group: `nsg-web`
* Subnet association: `WebSubnet`
* RDP access restricted to the administrator's public IP
* Network access controlled through security rules

### 📸 Screenshot 04 — Network Security Group

![Network Security Group](./images/04-nsg.png)

### 📸 Screenshot 05 — NSG Inbound Rules

![NSG Inbound Rules](./images/05-nsg-rules.png)

---

## 3. 🖥️ Windows Server Virtual Machine

A Windows Server virtual machine was deployed inside the Azure Virtual Network.

### Configuration

| Resource          | Configuration                                 |
| ----------------- | --------------------------------------------- |
| VM Name           | `vm-web-01`                                   |
| OS                | Windows Server 2022 Datacenter: Azure Edition |
| Size              | `B2als_v2`                                    |
| Availability Zone | Zone 1                                        |
| Private IP        | `10.0.1.4`                                    |
| Security          | Trusted Launch                                |

The VM was used to test network connectivity, Azure services, identity, and storage access.

### 📸 Screenshot 06 — Virtual Machine Overview

![Virtual Machine](./images/06-vm-overview.png)

### 📸 Screenshot 07 — VM Networking

![VM Networking](./images/07-vm-networking.png)

---

## 4. 🛣️ Routing

Custom routing was configured to demonstrate Azure network traffic flow and next-hop behavior.

### Configuration

| Setting          | Value       |
| ---------------- | ----------- |
| Route            | `0.0.0.0/0` |
| Next Hop Type    | Internet    |
| Next Hop Address | `10.0.1.10` |

The routing configuration was used as part of the network laboratory and troubleshooting exercises.

### 📸 Screenshot 08 — Route Table

![Route Table](./images/08-route-table.png)

### 📸 Screenshot 09 — Route Configuration

![Route Configuration](./images/09-route.png)

---

## 5. 📦 Azure Storage

An Azure Storage Account was deployed and used to test secure access from the Azure virtual machine.

The storage environment includes Blob Storage and private connectivity.

### 📸 Screenshot 10 — Storage Account

![Storage Account](./images/10-storage-account.png)

### 📸 Screenshot 11 — Blob Storage

![Blob Storage](./images/11-blob-storage.png)

---

## 6. 🔗 Private Endpoint & Private DNS

A Private Endpoint was configured to provide private network connectivity to Azure Blob Storage.

### Configuration

| Resource         | Configuration                       |
| ---------------- | ----------------------------------- |
| Private Endpoint | `pe-storage-01`                     |
| Target           | Azure Storage Blob                  |
| Private IP       | `10.0.1.5`                          |
| Private DNS Zone | `privatelink.blob.core.windows.net` |

This configuration demonstrates private access to Azure PaaS services without relying on a public endpoint.

### 📸 Screenshot 12 — Private Endpoint

![Private Endpoint](./images/12-private-endpoint.png)

### 📸 Screenshot 13 — Private DNS Zone

![Private DNS](./images/13-private-dns.png)

---

## 7. 🆔 Managed Identity & RBAC

A Managed Identity was used to provide the virtual machine with controlled access to Azure resources without storing credentials directly on the VM.

The VM identity was assigned the required Azure RBAC permission for Blob Storage access.

### Role Assignment

* Managed Identity
* Azure Storage
* `Storage Blob Data Reader`

### 📸 Screenshot 14 — Managed Identity

![Managed Identity](./images/14-managed-identity.png)

### 📸 Screenshot 15 — Role Assignment

![Role Assignment](./images/15-role-assignment.png)

---

## 8. 💻 Azure CLI

Azure CLI was used to manage and test Azure resources from the Windows Server environment.

The lab included authentication and resource interaction using Azure CLI.

### 📸 Screenshot 16 — Azure CLI

![Azure CLI](./images/16-azure-cli.png)

### 📸 Screenshot 17 — Azure CLI Identity / Resource Test

![Azure CLI Test](./images/17-azure-cli-test.png)

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
* Azure CLI authentication

Troubleshooting was performed by checking Azure networking, security rules, routing, DNS, identity, and resource configuration.

### 📸 Screenshot 18 — Network Connectivity Test

![Network Connectivity Test](./images/18-connectivity-test.png)

### 📸 Screenshot 19 — DNS Resolution Test

![DNS Resolution Test](./images/19-dns-test.png)

### 📸 Screenshot 20 — Storage Access Test

![Storage Access Test](./images/20-storage-test.png)

---

## 🛠️ Technologies

**Cloud**

Azure

**Infrastructure**

Azure Virtual Network · Virtual Machines · Azure Storage

**Networking**

VNet · Subnets · Routing · NSGs · Private Endpoints · Private DNS

**Identity**

Managed Identity · Azure RBAC

**Operating Systems**

Windows Server 2022

**Automation / Administration**

Azure CLI · PowerShell

---

## 📚 Skills Demonstrated

* Azure infrastructure deployment
* Virtual networking
* Subnet design
* Network security
* Routing
* Windows Server administration
* Azure Storage
* Private Endpoint configuration
* Private DNS
* Managed Identity
* RBAC
* Azure CLI
* Network troubleshooting
* Cloud infrastructure troubleshooting

---

## 🚀 Next Steps

Planned extensions to the Azure laboratory:

* Azure Active Directory / Microsoft Entra ID integration
* Hybrid identity with on-premises Active Directory
* Azure networking expansion
* Azure monitoring
* Infrastructure as Code with Terraform
* AWS + Azure hybrid connectivity

---

## 📌 Project Status

This laboratory is an ongoing practical cloud infrastructure project.

The environment is continuously expanded with new Azure services, networking scenarios, automation, and troubleshooting exercises.
