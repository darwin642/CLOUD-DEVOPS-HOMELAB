# 🔗 Hybrid Cloud Lab

A practical hybrid cloud laboratory combining **Microsoft Azure, Amazon Web Services, and an On-Premises Active Directory environment**.

The goal of the project is to connect cloud platforms with an existing On-Premises infrastructure and demonstrate practical **hybrid connectivity, hybrid identity, and cross-environment communication**.

---

## 📌 Project Overview

The project includes the following environments and technologies:

* Microsoft Azure
* Amazon Web Services
* On-Premises Active Directory
* Tailscale
* Hybrid Identity
* DNS
* Network Connectivity

The three environments are able to communicate with each other through the hybrid network.

The most important hybrid integration in the environment is between **On-Premises Active Directory and Microsoft Azure**.

The AWS environment is maintained as a separate cloud infrastructure, while still participating in the overall hybrid network through Tailscale.

---

## 🏗️ Architecture

![Tailscale Connectivity](hybrid-diagram.png)

The architecture consists of three main environments:

* ☁️ Microsoft Azure
* ☁️ Amazon Web Services
* 🪟 On-Premises Active Directory

All three environments are connected through **Tailscale**, providing network connectivity between the different infrastructure environments.

The primary hybrid identity connection is established between **On-Premises Active Directory and Azure** through Azure AD Connect.

---

## 1. 🔗 Hybrid Connectivity — Tailscale

**Tailscale provides the network connectivity layer between the On-Premises, Azure, and AWS environments.**

Instead of creating separate VPN connections between every environment, Tailscale provides a common private network that allows systems across the different environments to communicate.

### Connectivity

```text
                    HYBRID NETWORK
                         │
                  ┌──────▼──────┐
                  │  Tailscale  │
                  │ Private VPN │
                  └──────┬──────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
   ON-PREMISES        AZURE            AWS
   Active Directory   VNet             VPC
   Windows Server     Azure VM         EC2
```

Tailscale is used as the **network connectivity layer**, while the actual services and identities remain managed by their respective platforms.

This allows systems in the three environments to communicate using private network connectivity.

### Covered

* Private network connectivity
* Cross-environment communication
* On-Premises → Azure connectivity
* On-Premises → AWS connectivity
* Azure → AWS connectivity
* Tailscale subnet routing
* Hybrid network communication

For example, we can connect to AWS web01 virtual machine from our on-premises Windows Server machine called "HL-DC01".

### 📸 Screenshot — Tailscale Connectivity

![Tailscale Connectivity](tailscale-connectivity.png)

---

## 2. 🪟🔗☁️ On-Premises Active Directory ↔ Azure

This is the **primary hybrid integration** within the project.

The On-Premises Windows Server environment hosts the Active Directory infrastructure, while Microsoft Azure provides the cloud identity and infrastructure components.

The two environments are connected through both:

* **Network connectivity via Tailscale**
* **Identity synchronization via Azure AD Connect**

This creates a practical **hybrid identity environment** where users originating from the On-Premises Active Directory can be synchronized to Azure.

### Hybrid Identity Flow

```text
        ON-PREMISES
             │
             │
     ┌───────▼─────────┐
     │   HL-DC01       │
     │ Windows Server  │
     │                 │
     │ Active Directory│
     └────────┬────────┘
              │
              │ Azure AD Connect
              │
              ▼
     ┌──────────────────┐
     │ Microsoft Azure  │
     │                  │
     │ Azure Identity   │
     │ Cloud Resources  │
     └──────────────────┘
```

Azure AD Connect synchronizes identities between the On-Premises Active Directory environment and Azure.

This demonstrates how an organization can maintain an existing On-Premises Active Directory infrastructure while extending its identity environment into the cloud.

### Hybrid Components

* On-Premises Active Directory
* Windows Server Domain Controller
* Azure AD Connect
* Azure identity
* User synchronization
* Tailscale network connectivity

### 📸 Screenshot 01 — Azure AD Connect

![Azure AD Connect](azure-ad-connect2.png)

### 📸 Screenshot 02 — Synchronization

![Synchronization](synchronization.png)

---

## 3. ☁️ Microsoft Azure

Azure is one of the main cloud platforms within the hybrid infrastructure.

The Azure environment includes:

* Virtual Network
* Subnets
* Windows Server
* Private Endpoint
* Private DNS
* Managed Identity

The Azure environment is connected to the On-Premises infrastructure through Tailscale.

Azure also participates in the hybrid identity architecture through the integration with the On-Premises Active Directory environment.

### 📸 Screenshot — Azure Connectivity

![Azure Connectivity](azure-connectivity.png)

---

## 4. ☁️ Amazon Web Services

AWS is the second cloud platform within the hybrid cloud portfolio.

The AWS environment includes:

* VPC
* Public and private subnets
* EC2
* Security Groups
* Application Load Balancer

The AWS infrastructure is maintained as a separate cloud environment and managed with Terraform.

AWS is connected to the On-Premises and Azure environments through the shared Tailscale network.

This allows the AWS infrastructure to participate in the overall hybrid network without making AWS part of the Active Directory identity synchronization architecture.

### 📸 Screenshot — AWS Connectivity

![AWS Connectivity](aws-connectivity.png)

---

## 5. 🪟 On-Premises Active Directory

The On-Premises environment is built on Windows Server and provides the organization's central identity and Windows infrastructure services.

The environment includes:

* Active Directory Domain Services
* DNS
* DHCP
* Group Policy
* File Sharing
* Windows clients

The Active Directory environment is integrated with Azure using **Azure AD Connect**.

User identities are synchronized between the On-Premises Active Directory and Azure.

The On-Premises environment also participates in the hybrid network through Tailscale.

---

## 6. 🌐 Hybrid Communication

The three environments communicate through the Tailscale network:

```text
                 ┌─────────────────────┐
                 │      TAILSCALE      │
                 │ Hybrid Connectivity │
                 └──────────┬──────────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
          ▼                 ▼                 ▼
   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
   │ ON-PREMISES │   │    AZURE    │   │     AWS     │
   │             │   │             │   │             │
   │ HL-DC01     │◄─►│ Azure VNet  │◄─►│ AWS VPC     │
   │ AD DS       │   │ Azure VM    │   │ EC2         │
   │ DNS / DHCP  │   │             │   │ ALB         │
   └──────┬──────┘   └─────────────┘   └─────────────┘
          │
          │
          │ Azure AD Connect
          │
          ▼
   ┌─────────────────┐
   │ Azure Identity  │
   │ Hybrid Identity │
   └─────────────────┘
```

The important distinction is that **Tailscale provides network connectivity**, while **Azure AD Connect provides identity synchronization**.

Therefore:

**Tailscale = Network Connectivity**

**Azure AD Connect = Hybrid Identity**

This separation allows the lab to demonstrate both **hybrid networking** and **hybrid identity** within the same environment.

---

## 📌 Hybrid Lab Focus

This project demonstrates a practical hybrid infrastructure connecting **On-Premises Active Directory, Microsoft Azure, and AWS**.

The main hybrid integration is between **On-Premises Active Directory and Azure**, where Azure AD Connect provides identity synchronization.

At the network layer, **Tailscale connects all three environments**, allowing On-Premises, Azure, and AWS systems to communicate across the hybrid infrastructure.

The project therefore demonstrates:

* Hybrid networking
* Hybrid identity
* Active Directory integration with Azure
* Azure AD Connect
* Cross-cloud connectivity
* On-Premises to cloud communication
* Azure to AWS communication
* AWS to On-Premises communication
* Tailscale-based private connectivity
