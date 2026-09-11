# 🔗 Hybrid Cloud Lab

A practical hybrid cloud laboratory combining Microsoft Azure, Amazon Web Services, and an On-Premises Active Directory environment.

The goal of the project is to connect cloud platforms with an existing Active Directory infrastructure and build a practical hybrid infrastructure environment.

---

## 📌 Project Overview

The project includes the following environments:

* Microsoft Azure
* Amazon Web Services
* On-Premises Active Directory
* Tailscale
* Hybrid Identity
* DNS
* Network Connectivity

The On-Premises Active Directory environment is **integrated with Azure**.

The AWS environment is maintained as a separate cloud infrastructure within the project.

---

## 🏗️ Architecture

### Architecture Diagram

> **[ADD YOUR HYBRID CLOUD ARCHITECTURE DIAGRAM HERE]**

<!-- Add your Azure + AWS + On-Premises Active Directory + Tailscale architecture diagram here -->

The architecture consists of Azure and AWS cloud environments together with an On-Premises Active Directory infrastructure.

Network communication between the On-Premises environment and Azure is provided through **Tailscale**.

---

## 1. ☁️ Microsoft Azure

Azure is one of the main cloud platforms in the hybrid infrastructure.

The Azure environment includes Virtual Network, subnets, Windows Server, Private Endpoint, Private DNS, and Managed Identity.

The On-Premises Active Directory environment has been integrated with Azure to implement a hybrid identity scenario.

### 📸 Screenshot 01 — Azure Connectivity

![Azure Connectivity](./images/01-azure-connectivity.png)

---

## 2. ☁️ Amazon Web Services

AWS is the second cloud platform within the hybrid cloud portfolio.

The AWS environment includes VPC, public/private subnets, EC2, Security Groups, and Application Load Balancer.

The AWS infrastructure is maintained as a separate cloud environment and managed with Terraform.

### 📸 Screenshot 02 — AWS Connectivity

![AWS Connectivity](./images/02-aws-connectivity.png)

---

## 3. 🪟 On-Premises Active Directory

The On-Premises Active Directory environment is built on Windows Server.

The Active Directory environment is integrated with Azure using **Azure AD Connect**.

User identities are synchronized between Active Directory and Azure.

### 📸 Screenshot 03 — Azure AD Connect

![Azure AD Connect](./images/03-azure-ad-connect.png)

### 📸 Screenshot 04 — Synchronization

![Synchronization](./images/04-synchronization.png)

---

## 4. 🔗 Azure — On-Premises Connectivity

Network communication between the On-Premises Active Directory en
