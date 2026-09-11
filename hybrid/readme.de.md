# 🔗 Hybrid Cloud Lab

Eine praktische Hybrid-Cloud-Laborumgebung, die Microsoft Azure, Amazon Web Services und eine On-Premises Active Directory-Umgebung miteinander verbindet.

Ziel des Projekts ist es, Cloud-Plattformen mit einer bestehenden Active Directory-Infrastruktur zu verbinden und eine praktische Hybrid-Infrastruktur aufzubauen.

---

## 📌 Projektübersicht

Das Projekt umfasst folgende Umgebungen:

* Microsoft Azure
* Amazon Web Services
* On-Premises Active Directory
* Tailscale
* Hybrid Identity
* DNS
* Netzwerkkommunikation

Die On-Premises Active Directory-Umgebung ist **mit Azure integriert**.

Die AWS-Umgebung wird als separate Cloud-Infrastruktur innerhalb des Projekts betrieben.

---

## 🏗️ Architektur

### Architekturdiagramm

> **[HYBRID-CLOUD-ARCHITEKTURDIAGRAMM HIER EINFÜGEN]**

<!-- Azure + AWS + On-Premises Active Directory + Tailscale Architekturdiagramm hier einfügen -->

Die Architektur besteht aus Azure- und AWS-Cloud-Umgebungen sowie einer On-Premises Active Directory-Infrastruktur.

Die Netzwerkkommunikation zwischen der On-Premises-Umgebung und Azure wird über **Tailscale** bereitgestellt.

---

## 1. ☁️ Microsoft Azure

Azure ist eine der wichtigsten Cloud-Plattformen innerhalb der Hybrid-Infrastruktur.

Die Azure-Umgebung umfasst Virtual Network, Subnetze, Windows Server, Private Endpoint, Private DNS und Managed Identity.

Die On-Premises Active Directory-Umgebung wurde mit Azure integriert, um ein Hybrid-Identity-Szenario umzusetzen.

### 📸 Screenshot 01 — Azure Connectivity

![Azure Connectivity](./images/01-azure-connectivity.png)

---

## 2. ☁️ Amazon Web Services

AWS ist die zweite Cloud-Plattform innerhalb des Hybrid-Cloud-Portfolios.

Die AWS-Umgebung umfasst VPC, öffentliche/private Subnetze, EC2, Security Groups und Application Load Balancer.

Die AWS-Infrastruktur wird als separate Cloud-Umgebung betrieben und mit Terraform verwaltet.

### 📸 Screenshot 02 — AWS Connectivity

![AWS Connectivity](./images/02-aws-connectivity.png)

---

## 3. 🪟 On-Premises Active Directory

Die On-Premises Active Directory-Umgebung wurde auf Windows Server aufgebaut.

Die Active Directory-Umgebung wurde mit **Azure AD Connect** in Azure integriert.

Benutzeridentitäten werden zwischen Active Directory und Azure synchronisiert.

### 📸 Screenshot 03 — Azure AD Connect

![Azure AD Connect](./images/03-azure-ad-connect.png)

### 📸 Screenshot 04 — Synchronisierung

![Synchronisierung](./images/04-synchronization.png)

---

## 4. 🔗 Azure — On-Premises Connectivity

Die Netzwerkkommunikation zwischen der On-Premises Active Directory-Umgebung und Azure wird über **Tailscale** bereitgestellt.

Dadurch wird eine private Netzwerkkommunikation zwischen der On-Premises- und der Azure-Umgebung ermöglicht.

### 📸 Screenshot 05 — Tailscale

![Tailscale](./images/05-tailscale.png)

### 📸 Screenshot 06 — Azure / On-Premises Connectivity Test

![Connectivity Test](./images/06-connectivity-test.png)

---

## 5. 🧪 Hybrid Connectivity Test

Die Hybrid-Umgebung wird über folgende Verbindungen getestet:

* On-Premises → Azure
* Azure → On-Premises
* DNS-Auflösung
* Private-IP-Kommunikation
* Tailscale-Konnektivität

Die AWS-Umgebung wird separat über das eigene VPC-Netzwerk und die verwendeten Cloud-Services getestet.

### 📸 Screenshot 07 — Connectivity Test

![Connectivity Test](./images/07-connectivity-test.png)

### 📸 Screenshot 08 — DNS Test

![DNS Test](./images/08-dns-test.png)

---

## 🛠️ Technologien

**Cloud**

Azure · AWS

**Identity**

Active Directory · Azure AD Connect

**Networking**

VNet · VPC · Subnetze · DNS · Tailscale

**Hybrid**

Hybrid Identity · Hybrid Connectivity

**Infrastructure as Code**

Terraform

---

## 📚 Gezeigte Kenntnisse

* Azure-Infrastruktur
* AWS-Infrastruktur
* Hybrid-Cloud-Konzepte
* Active Directory-Integration
* Hybrid Identity
* Azure AD Connect
* DNS
* Netzwerkkommunikation
* Tailscale Networking
* Terraform
* Cloud-Infrastruktur-Troubleshooting

---

## 🚀 Nächste Schritte

* Erweiterung der Azure + AWS Hybrid Connectivity
* Erweiterung der Hybrid-Infrastruktur mit Terraform
* Docker-Integration
* Kubernetes-Umgebung
* Cloud/DevOps-Automatisierung

---

## 📌 Projektstatus

Dieses Labor ist ein fortlaufendes **Hybrid-Cloud-Projekt**, das Azure, AWS und eine On-Premises Active Directory-Umgebung kombiniert.

Die On-Premises Active Directory-Umgebung ist über Tailscale und Azure AD Connect mit Azure verbunden.
